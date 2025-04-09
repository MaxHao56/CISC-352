import os
import re
import pandas as pd
import numpy as np
import torch
import torch.nn as nn
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import PowerTransformer, LabelEncoder

# Import the BNN components from your separate file.
# Ensure that bnn.py is in the same directory or in the Python path.
from Final_Project.Medical_final_Result.Final_BNN_model import BNN_Alpha, train_model, predict_patient


def run_plan_manager(actions, data_file):
    """
    For each plan in the actions dictionary, this function:
      - Loads the cancer dataset,
      - Subsets the columns based on the provided list of features for that plan,
      - Encodes and scales the feature values,
      - Trains a Bayesian neural network model (BNN_Alpha) using these features only,
      - Makes a single patient prediction using the trained model,
      - Returns and prints the prediction probability along with a recommendation.

    Parameters:
      actions (dict): A dictionary where keys are plan numbers and values are lists of feature names.
      data_file (str): File path to the cancer data CSV.

    Returns:
      dict: A dictionary with plan numbers as keys. Each value is another dict containing:
            - 'chance': the mean predicted probability,
            - 'uncertainty': the standard deviation of the predictions,
            - 'recommendation': a string advising whether to worry (go hospital) or not.
    """
    # Load the dataset
    if not os.path.exists(data_file):
        raise FileNotFoundError(f"Data file not found at {data_file}")
    df = pd.read_csv(data_file)
    
    # Drop columns that are not needed
    df.drop(columns=['id', 'Unnamed: 32'], inplace=True, errors='ignore')
    
    # Encode the diagnosis column
    df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])
    
    # Create a PowerTransformer instance (Yeo-Johnson, as in your BNN file)
    transformer = PowerTransformer(method='yeo-johnson')
    
    results = {}
    
    # Iterate over each plan from the actions dictionary
    for plan_key, feature_list in actions.items():
        # Select only those features which are present in the dataframe
        available_features = [feat for feat in feature_list if feat in df.columns]
        if not available_features:
            print(f"No available features for plan {plan_key}. Skipping.")
            continue
        
        # Ensure the target column 'diagnosis' is present
        selected_cols = available_features + ['diagnosis']
        plan_df = df[selected_cols].copy()
        
        # Separate features and labels
        X = plan_df[available_features].values
        y = plan_df['diagnosis'].values
        
        # Apply PowerTransformer to features (leaving the labels unchanged)
        X = transformer.fit_transform(X)
        
        # Convert data to torch tensors
        X_tensor = torch.tensor(X, dtype=torch.float32)
        y_tensor = torch.tensor(y, dtype=torch.float32).unsqueeze(1)
        
        # Split into training and test sets
        X_train, X_test, y_train, y_test = train_test_split(
            X_tensor, y_tensor, test_size=0.3, random_state=42
        )
        
        # Define and train the Bayesian Neural Network using only these features.
        model = BNN_Alpha(input_dim=X_train.shape[1], hidden_dim=20, output_dim=1)
        model = train_model(
            model, 
            nn.BCELoss(), 
            X_train, 
            y_train,
            epochs=200, 
            lr=0.01, 
            beta=0.01, 
            reg_fn=lambda: model.alpha_div(alpha=0.5)
        )
        
        # Predict on a single patient (e.g., the first patient in the test set)
        patient_vector = X_test[0].detach().numpy()
        mean_pred, std_pred = predict_patient(model, patient_vector, n_samples=100)
        
        # Make a recommendation based on the model prediction:
        # if chance is below 50%, then "No need to worry"; otherwise "Go hospital"
        recommendation = "No need to worry" if mean_pred < 0.5 else "Go hospital"
        
        results[plan_key] = {
            "chance": mean_pred,
            "uncertainty": std_pred,
            "recommendation": recommendation
        }
        
        print(f"Plan {plan_key}:")
        print(f"  Chance of Cancer: {mean_pred * 100:.2f}%")
        print(f"  Prediction Uncertainty: {std_pred:.4f}")
        print(f"  Recommendation: {recommendation}\n")
    
    return results


if __name__ == "__main__":
    # Example actions dictionary from your planning extension
    actions = {
        1: ['perimeter_mean', 'perimeter_se', 'perimeter_worst', 
            'area_mean', 'area_se', 'area_worst', 
            'fractaldimension_mean', 'fractaldimension_se', 'fractaldimension_worst'],
        2: ['perimeter_mean', 'perimeter_se', 'perimeter_worst', 
            'area_mean', 'area_se', 'area_worst', 
            'fractaldimension_mean', 'fractaldimension_se', 'fractaldimension_worst', 
            'symmetry_mean', 'symmetry_se', 'symmetry_worst', 
            'smoothness_mean', 'smoothness_se', 'smoothness_worst', 
            'perimeter_mean', 'perimeter_se', 'perimeter_worst', 
            'area_mean', 'area_se', 'area_worst', 
            'fractaldimension_mean', 'fractaldimension_se', 'fractaldimension_worst', 
            'symmetry_mean', 'symmetry_se', 'symmetry_worst', 
            'texture_mean', 'texture_se', 'texture_worst', 
            'perimeter_mean', 'perimeter_se', 'perimeter_worst', 
            'area_mean', 'area_se', 'area_worst', 
            'fractaldimension_mean', 'fractaldimension_se', 'fractaldimension_worst', 
            'texture_mean', 'texture_se', 'texture_worst', 
            'smoothness_mean', 'smoothness_se', 'smoothness_worst'],
        3: ['perimeter_mean', 'perimeter_se', 'perimeter_worst', 
            'area_mean', 'area_se', 'area_worst', 
            'fractaldimension_mean', 'fractaldimension_se', 'fractaldimension_worst', 
            'smoothness_mean', 'smoothness_se', 'smoothness_worst', 
            'texture_mean', 'texture_se', 'texture_worst', 
            'texture_mean', 'texture_se', 'texture_worst']
    }
    
    # Replace with the correct path to your CSV file
    data_file_path = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/datasets/Cancer_Data.csv"
    
    # Run the plan manager which processes each plan and prints the recommendations
    run_plan_manager(actions, data_file_path)
