import pandas as pd
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import PowerTransformer, LabelEncoder


######################
# DATA LOADING & PREPROCESSING
######################
file_path = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/datasets/Cancer_Data.csv"
df = pd.read_csv(file_path)

# Remove unnecessary columns if present
df.drop(columns=['id'], inplace=True, errors='ignore')
df.drop(columns=['Unnamed: 32'], inplace=True, errors='ignore')

# Encode diagnosis column into 0 and 1 (benign/malignant)
df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])

# Separate features and labels
X = df.drop(columns=['diagnosis']).values
y = df['diagnosis'].values

# Transform features using PowerTransformer (Yeo-Johnson)
scaler = PowerTransformer(method='yeo-johnson')
X = scaler.fit_transform(X)

# Convert arrays to PyTorch tensors
X = torch.tensor(X, dtype=torch.float32)
y = torch.tensor(y, dtype=torch.float32)

# Split into training and test sets; reshape labels for BCELoss compatibility
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
X_train_tensor = torch.tensor(X_train, dtype=torch.float32)
y_train_tensor = torch.tensor(y_train, dtype=torch.float32).unsqueeze(1)
X_test_tensor = torch.tensor(X_test, dtype=torch.float32)
y_test_tensor = torch.tensor(y_test, dtype=torch.float32).unsqueeze(1)

######################
# MODEL DEFINITIONS (α-Divergence Based)
######################
def alpha_divergence(q_mu, q_sigma, alpha=0.5):
    # A simple formulation for α-divergence between q (approximate posterior) and the prior
    return (1 / (alpha * (1 - alpha))) * (1 - torch.exp(-alpha * (q_mu ** 2 + q_sigma ** 2) / 2).sum())

class BayesianLinearAlpha(nn.Module):
    def __init__(self, in_features, out_features):
        super().__init__()
        self.mu = nn.Parameter(torch.randn(out_features, in_features) * 0.1)
        self.rho = nn.Parameter(torch.randn(out_features, in_features) * -3.0)

    def forward(self, x):
        std = torch.log1p(torch.exp(self.rho))
        eps = torch.randn_like(std)
        weight = self.mu + std * eps
        return F.linear(x, weight)

    def alpha_div(self, alpha=0.5):
        std = torch.log1p(torch.exp(self.rho))
        return alpha_divergence(self.mu, std, alpha=alpha)

class BNN_Alpha(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim):
        super().__init__()
        self.fc1 = BayesianLinearAlpha(input_dim, hidden_dim)
        self.fc2 = BayesianLinearAlpha(hidden_dim, output_dim)

    def forward(self, x):
        x = F.relu(self.fc1(x))
        return torch.sigmoid(self.fc2(x))

    def alpha_div(self, alpha=0.5):
        return self.fc1.alpha_div(alpha) + self.fc2.alpha_div(alpha)

######################
# TRAINING FUNCTION
######################
def train_model(model, loss_fn, X, y, epochs=200, lr=0.01, beta=0.01, reg_fn=None):
    optimizer = optim.Adam(model.parameters(), lr=lr)
    for epoch in range(epochs):
        model.train()
        optimizer.zero_grad()
        output = model(X)
        loss = loss_fn(output, y)
        if reg_fn is not None:
            loss += beta * reg_fn()
        loss.backward()
        optimizer.step()
    return model

######################
# SINGLE PATIENT PREDICTION FUNCTION
######################
def predict_patient(model, patient_vector, n_samples=100):
    """
    Given a preprocessed 1D patient_vector (numpy array of features),
    returns:
       - Mean predicted probability (chance of cancer)
       - Standard deviation (uncertainty) of that prediction.
    """
    # Convert the vector to a tensor and add a batch dimension: shape (1, num_features)
    patient_tensor = torch.tensor(patient_vector, dtype=torch.float32).unsqueeze(0)
    model.train()  # Use train mode to ensure stochastic sampling (activates Bayesian behavior)
    preds = []
    for _ in range(n_samples):
        out = model(patient_tensor)
        preds.append(out.item())
    preds = np.array(preds)
    mean_pred = preds.mean()
    std_pred = preds.std()
    return mean_pred, std_pred

######################
# MAIN: TRAIN THE MODEL AND PREDICT A SINGLE PATIENT
######################
print("Training the α-Divergence based Bayesian NN...")
bnn_alpha = BNN_Alpha(input_dim=X_train_tensor.shape[1], hidden_dim=20, output_dim=1)
bnn_alpha = train_model(bnn_alpha, nn.BCELoss(), X_train_tensor, y_train_tensor,
                        epochs=200, lr=0.1, beta=0.01, reg_fn=lambda: bnn_alpha.alpha_div(alpha=0.5))

# Example: Use a single patient from the test set.
# Ensure that the patient vector is preprocessed the same way as the training data.
patient_example = X_test[10]  # This is a numpy array for one patient.
chance, uncertainty = predict_patient(bnn_alpha, patient_example, n_samples=100)

print("Chance of Cancer: {:.2f}%".format(chance * 100))
print("Standard Deviation: {:.4f}".format(uncertainty))
