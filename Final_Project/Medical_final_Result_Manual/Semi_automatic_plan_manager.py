import os
import pandas as pd
import numpy as np
import torch
import torch.nn as nn
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import PowerTransformer, LabelEncoder

import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from env import *

######################
# IMPORT THE BNN API FROM THE ACTUAL BNN_MODEL.PY FILE
######################

from FInal_BNN_Manual import BNN_Alpha, train_model, predict_patient

######################
# DATA LOADING & PREPROCESSING
######################
def load_data(csv_file_path):
    """
    Loads the cancer data CSV, drops extraneous columns,
    and encodes the diagnosis column (target) into binary values.
    """
    if not os.path.exists(csv_file_path):
        raise FileNotFoundError(f"CSV file not found at: {csv_file_path}")
    
    df = pd.read_csv(csv_file_path)
    df.drop(columns=['id', 'Unnamed: 32'], inplace=True, errors='ignore')
    # Encode diagnosis (e.g., benign/malignant) into 0 and 1.
    df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])
    return df

######################
# INTERACTIVE PLAN MANAGER FUNCTION
######################
def run_plan_manager(csv_file_path):
    """
    This function does the following:
      1. Loads the dataset.
      2. Lists available features (all columns except 'diagnosis') and prompts the user
         for how many features to use and then the names of those features.
      3. Filters the dataset to the chosen features and the diagnosis target.
      4. Splits the data into:
         - Upcoming patients: the first 25 rows (used only for prediction)
         - Test set: the next 25 rows (used to compute accuracy)
         - Training set: the remaining rows.
      5. Scales the features using PowerTransformer (fitted on training data).
      6. Trains the BNN_Alpha model (which uses α-divergence regularization) on training data.
      7. Evaluates test set accuracy and predicts on all upcoming patients,
         printing each patient’s chance of cancer and the uncertainty.
    Returns a results dictionary.
    """
    # Load and preprocess data
    df = load_data(csv_file_path)
    
    # List available features (all except the target 'diagnosis')
    available_features = [col for col in df.columns if col != 'diagnosis']
    print("Available features for training:")
    for i, feat in enumerate(available_features, 1):
        print(f"{i}. {feat}")
    
    # Interactive prompt: Ask user how many features to train on.
    num_features_str = input("\nHow many features do you want to train on? ").strip()
    try:
        num_features = int(num_features_str)
    except ValueError:
        print("Invalid number entered. Exiting.")
        return None
    
    selected_features = []
    for i in range(num_features):
        while True:
            feat = input(f"Enter feature {i+1} name: ").strip()
            if feat in available_features:
                selected_features.append(feat)
                break
            else:
                print("Feature not found. Please enter a valid feature from the list above.")
    print("\nSelected features for training:", selected_features)
    
    # Filter dataframe to only selected features plus diagnosis
    df_selected = df[selected_features + ['diagnosis']].copy()
    
    # Split the data:
    #  - Upcoming patients: first 25 rows
    #  - Test set: next 25 rows
    #  - Training set: remaining rows
    upcoming_df = df_selected.iloc[:25].reset_index(drop=True)
    test_df = df_selected.iloc[25:50].reset_index(drop=True)
    train_df = df_selected.iloc[50:].reset_index(drop=True)
    
    # Separate features and target for train and test
    X_train = train_df[selected_features].values
    y_train = train_df['diagnosis'].values
    X_test = test_df[selected_features].values
    y_test = test_df['diagnosis'].values
    X_upcoming = upcoming_df[selected_features].values  # For prediction
    
    # Scale features using PowerTransformer (fit on training set)
    transformer = PowerTransformer(method='yeo-johnson')
    X_train_scaled = transformer.fit_transform(X_train)
    X_test_scaled = transformer.transform(X_test)
    X_upcoming_scaled = transformer.transform(X_upcoming)
    
    # Convert arrays to PyTorch tensors
    X_train_tensor = torch.tensor(X_train_scaled, dtype=torch.float32)
    y_train_tensor = torch.tensor(y_train, dtype=torch.float32).unsqueeze(1)
    X_test_tensor = torch.tensor(X_test_scaled, dtype=torch.float32)
    y_test_tensor = torch.tensor(y_test, dtype=torch.float32).unsqueeze(1)
    
    # Instantiate and train the model using BNN_Alpha from BNN_model API.
    print("\nTraining the BNN_Alpha model on the selected features...")
    # Note: the input dimension is the number of selected features.
    model = BNN_Alpha(input_dim=len(selected_features), hidden_dim=20, output_dim=1)
    model = train_model(model, nn.BCELoss(), X_train_tensor, y_train_tensor,
                        epochs=200, lr=0.1, beta=0.01, reg_fn=lambda: model.alpha_div(alpha=0.5))
    
    # Evaluate the model on the test set.
    def evaluate_model(model, X_test, y_test, n_samples=100, threshold=0.5):
        predictions = []
        true_labels = []
        for i in range(len(X_test)):
            patient_vector = X_test[i].detach().numpy()
            mean_pred, _ = predict_patient(model, patient_vector, n_samples=n_samples)
            predicted_label = 1 if mean_pred >= threshold else 0
            predictions.append(predicted_label)
            true_labels.append(int(y_test[i].item()))
        predictions = np.array(predictions)
        true_labels = np.array(true_labels)
        return np.mean(predictions == true_labels)
    
    test_acc = evaluate_model(model, X_test_tensor, y_test_tensor, n_samples=100)
    print(f"\nTest Set Accuracy: {test_acc*100:.2f}%")
    
    # Predict on each upcoming patient.
    print("\nPredictions for Upcoming Patients:")
    upcoming_results = []
    for idx, patient_vec in enumerate(X_upcoming_scaled):
        mean_pred, std_pred = predict_patient(model, patient_vec, n_samples=100)
        recommendation = "Go to hospital" if mean_pred >= 0.5 else "No need to worry"
        upcoming_results.append({
            "patient_id": idx + 1,
            "chance": mean_pred,
            "uncertainty": std_pred,
            "recommendation": recommendation
        })
        print(f"Patient {idx+1}: Chance = {mean_pred*100:.2f}%, Uncertainty = {std_pred:.4f}, Recommendation = {recommendation}")
    
    # Return the results dictionary if needed for further processing.
    results = {
        "selected_features": selected_features,
        "test_accuracy": test_acc,
        "upcoming_predictions": upcoming_results
    }
    return results

######################
# MAIN EXECUTION
######################
if __name__ == '__main__':
    data_csv_path = CANCER_DATA_FILE
    results = run_plan_manager(data_csv_path)
    if results is not None:
        print("\nFinal Results:")
        print("Selected Features:", results["selected_features"])
        print("Test Accuracy: {:.2f}%".format(results["test_accuracy"]*100))
        for pred in results["upcoming_predictions"]:
            print(f"Patient {pred['patient_id']}: Chance = {pred['chance']*100:.2f}%, "
                  f"Uncertainty = {pred['uncertainty']:.4f}, Recommendation = {pred['recommendation']}")
