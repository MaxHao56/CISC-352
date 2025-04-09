import os
import pandas as pd
import numpy as np
import torch
import torch.nn as nn
from sklearn.preprocessing import PowerTransformer, LabelEncoder
from sklearn.model_selection import train_test_split

import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from env import *

# Import the Bayesian Neural Network components from your BNN file.
from Final_BNN_model import BNN_Alpha, train_model, predict_patient

# Import the planning extension function that extracts PDDL actions.
from Planning_extension import load_pddl_actions

def evaluate_model(model, X_test, y_test, n_samples=100, threshold=0.5):
    predictions = []
    true_labels = []
    
    for i in range(len(X_test)):
        patient_vector = X_test[i].detach().numpy()
        mean_pred, _ = predict_patient(model, patient_vector, n_samples=n_samples)
        predicted_label = 1 if mean_pred >= threshold else 0
        predictions.append(predicted_label)
        true_labels.append(int(y_test[i].item()))
    
    accuracy = np.mean(np.array(predictions) == np.array(true_labels))
    return accuracy

def run_plan_manager(actions, data_file):
    if not os.path.exists(data_file):
        raise FileNotFoundError(f"Data file not found at {data_file}")
    
    df = pd.read_csv(data_file)
    df.drop(columns=['id', 'Unnamed: 32'], inplace=True, errors='ignore')
    df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])

    results = {}
    
    for plan_key, feature_sets in actions.items():
        # Normalize single feature list to a list of lists
        if isinstance(feature_sets[0], str):
            feature_sets = [feature_sets]
        
        print(f"\nProcessing plan '{plan_key}' with {len(feature_sets)} feature set(s)...")
        results[plan_key] = {}

        for i, feature_list in enumerate(feature_sets):
            print(f"\n   Feature Set {i+1}: {feature_list}")

            available_features = [feat for feat in feature_list if feat in df.columns]
            if not available_features:
                print(f"     No valid features found. Skipping.")
                continue

            selected_cols = available_features + ['diagnosis']
            plan_df = df[selected_cols].copy()

            new_pat_df = plan_df.iloc[:25].reset_index(drop=True)
            test_df = plan_df.iloc[25:50].reset_index(drop=True)
            train_df = plan_df.iloc[50:].reset_index(drop=True)

            X_train = train_df[available_features].values
            y_train = train_df['diagnosis'].values
            X_test = test_df[available_features].values
            y_test = test_df['diagnosis'].values

            transformer = PowerTransformer(method='yeo-johnson')
            X_train = transformer.fit_transform(X_train)
            X_test = transformer.transform(X_test)
            X_new_patient = transformer.transform(new_pat_df[available_features].values)

            X_train_tensor = torch.tensor(X_train, dtype=torch.float32)
            y_train_tensor = torch.tensor(y_train, dtype=torch.float32).unsqueeze(1)
            X_test_tensor = torch.tensor(X_test, dtype=torch.float32)
            y_test_tensor = torch.tensor(y_test, dtype=torch.float32).unsqueeze(1)

            model = BNN_Alpha(input_dim=X_train_tensor.shape[1], hidden_dim=20, output_dim=1)
            model = train_model(
                model,
                nn.BCELoss(),
                X_train_tensor,
                y_train_tensor,
                epochs=200,
                lr=0.1,
                beta=0.01,
                reg_fn=lambda: model.alpha_div(alpha=0.5)
            )

            print("    --- Predictions for Upcoming Patients ---")
            patient_results = []
            go_count = 0

            for idx, patient_vector in enumerate(X_new_patient):
                mean_pred, std_pred = predict_patient(model, patient_vector, n_samples=100)
                recommendation = "No need to worry" if mean_pred < 0.5 else "Go to hospital"
                if recommendation == "Go to hospital":
                    go_count += 1

                print(f"    Patient {idx + 1}: Chance: {mean_pred * 100:.2f}%, Uncertainty: {std_pred:.4f}, Rec: {recommendation}")
                patient_results.append({
                    "chance": mean_pred,
                    "uncertainty": std_pred,
                    "recommendation": recommendation
                })

            print(f"     Total patients recommended to go to hospital: {go_count} / 25")

            test_accuracy = evaluate_model(model, X_test_tensor, y_test_tensor, n_samples=100, threshold=0.5)

            results[plan_key][f"feature_set_{i+1}"] = {
                "features": available_features,
                "test_accuracy": test_accuracy,
                "hospital_recommendations": go_count,
                "patient_predictions": patient_results
            }



if __name__ == "__main__":
    domain_file = PLANNING_DOMAIN_DIR
    data_file_path = CANCER_DATA_FILE
    
    actions = load_pddl_actions(domain_file)
    print("Extracted actions from planning extension:")
    print(actions)
    
    run_plan_manager(actions, data_file_path)
