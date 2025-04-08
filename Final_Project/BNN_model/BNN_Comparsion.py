import pandas as pd
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import PowerTransformer, LabelEncoder
from sklearn.metrics import accuracy_score, confusion_matrix, roc_curve, auc, precision_recall_curve





######################
# DATA LOADING & PREPROCESSING
######################
file_path = "C:/Users/maxha/OneDrive/Documents/GitHub/CISC-352/Final_Project/datasets/Cancer_Data.csv"
df = pd.read_csv(file_path)


# Remove unnecessary columns (if present)
df.drop(columns=['id'], inplace=True, errors='ignore')
df.drop(columns=['Unnamed: 32'], inplace=True, errors='ignore')

# Encode diagnosis column (e.g., benign/malignant) into 0 and 1
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

# Split into train and test sets and reshape label tensors for BCELoss compatibility
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
X_train_tensor = torch.tensor(X_train, dtype=torch.float32)
y_train_tensor = torch.tensor(y_train, dtype=torch.float32).unsqueeze(1)
X_test_tensor = torch.tensor(X_test, dtype=torch.float32)
y_test_tensor = torch.tensor(y_test, dtype=torch.float32).unsqueeze(1)

######################
# MODEL DEFINITIONS
######################
# --- Bayesian Neural Network using KL Divergence ---
class BayesianLinear(nn.Module):
    def __init__(self, in_features, out_features, prior_std=1.0):
        super().__init__()
        self.mu = nn.Parameter(torch.randn(out_features, in_features) * 0.1)
        self.rho = nn.Parameter(torch.randn(out_features, in_features) * -3.0)
        self.prior_std = prior_std

    def forward(self, x):
        std = torch.log1p(torch.exp(self.rho))
        eps = torch.randn_like(std)
        weight = self.mu + std * eps
        return F.linear(x, weight)

    def kl_divergence(self):
        std = torch.log1p(torch.exp(self.rho))
        return ((std**2 + self.mu**2 - 2 * torch.log(std) - 1) / (2 * self.prior_std**2)).sum()

class BNN_KL(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim):
        super().__init__()
        self.fc1 = BayesianLinear(input_dim, hidden_dim)
        self.fc2 = BayesianLinear(hidden_dim, output_dim)

    def forward(self, x):
        x = F.relu(self.fc1(x))
        return torch.sigmoid(self.fc2(x))

    def kl_divergence(self):
        return self.fc1.kl_divergence() + self.fc2.kl_divergence()

# --- Bayesian Neural Network using α-Divergence ---
def alpha_divergence(q_mu, q_sigma, alpha=0.5):
    kl = (1 / (alpha * (1 - alpha))) * (1 - torch.exp(-alpha * (q_mu ** 2 + q_sigma ** 2) / 2).sum())
    return kl

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

# --- Monte Carlo Dropout Network for Uncertainty ---
class MCDropoutNN(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim, p=0.5):
        super().__init__()
        self.fc1 = nn.Linear(input_dim, hidden_dim)
        self.dropout = nn.Dropout(p)
        self.fc2 = nn.Linear(hidden_dim, output_dim)

    def forward(self, x):
        x = F.relu(self.fc1(x))
        # Dropout remains active when using train() mode for MC sampling.
        x = self.dropout(x)
        return torch.sigmoid(self.fc2(x))

    def predict_mc(self, x, n=100):
        # For MC sampling the dropout is activated.
        self.train()
        preds = [self.forward(x) for _ in range(n)]
        return torch.stack(preds).mean(0)

# --- Deterministic Simple Neural Network (for comparison) ---
class SimpleNN(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim):
        super().__init__()
        self.fc1 = nn.Linear(input_dim, hidden_dim)
        self.fc2 = nn.Linear(hidden_dim, output_dim)

    def forward(self, x):
        x = F.relu(self.fc1(x))
        return torch.sigmoid(self.fc2(x))

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
        if reg_fn:
            loss += beta * reg_fn()
        loss.backward()
        optimizer.step()
    return model

######################
# UNIFIED EVALUATION FUNCTION
######################
def evaluate_model(model, X_test, y_test, n_samples=100, stochastic=True):
    """
    Unified evaluation function for both stochastic (Bayesian, MC Dropout) and deterministic models.
    
    Args:
      model: the neural network model.
      X_test: test features tensor.
      y_test: true labels array.
      n_samples: number of forward passes (only used if stochastic=True).
      stochastic: if True, performs MC sampling using train() mode; 
                  if False, uses a single forward pass in eval() mode.
    """
    if stochastic:
        # Activate stochastic behavior (e.g., Bayesian sampling or dropout)
        model.train()  
        preds = []
        for _ in range(n_samples):
            out = model(X_test)
            preds.append(out.detach().cpu().numpy())
        preds = np.array(preds)  # shape: (n_samples, num_samples, 1)
        mean_preds = preds.mean(axis=0).flatten()
        std_preds = preds.std(axis=0).flatten()
    else:
        # Deterministic mode: use eval()
        model.eval()
        out = model(X_test)
        mean_preds = out.detach().cpu().numpy().flatten()
        std_preds = np.zeros_like(mean_preds)
    
    # Classification decision based on a threshold of 0.5
    y_pred = (mean_preds >= 0.5).astype(int)
    acc = accuracy_score(y_test, y_pred)
    print("Accuracy: {:.4f}".format(acc))
    print("Confusion Matrix:\n", confusion_matrix(y_test, y_pred))
    
    # Plot predictions with error bars (uncertainty)
    sample_indices = np.arange(len(mean_preds))
    plt.figure(figsize=(12, 6))
    plt.errorbar(sample_indices, mean_preds, yerr=std_preds, fmt='o',
                 ecolor='lightgray', elinewidth=2, capsize=3, label="Mean Prediction ± Std")
    plt.axhline(0.5, color='r', linestyle='--', label="Threshold (0.5)")
    plt.xlabel("Test Sample Index")
    plt.ylabel("Predicted Probability")
    plt.title("Model Predictions and Uncertainty")
    plt.legend()
    plt.show()
    
    # ROC Curve
    fpr, tpr, _ = roc_curve(y_test, mean_preds)
    roc_auc = auc(fpr, tpr)
    plt.figure(figsize=(8, 6))
    plt.plot(fpr, tpr, label=f"ROC Curve (AUC = {roc_auc:.2f})")
    plt.plot([0, 1], [0, 1], 'k--')
    plt.xlabel("False Positive Rate")
    plt.ylabel("True Positive Rate")
    plt.title("ROC Curve")
    plt.legend(loc="lower right")
    plt.show()
    
    # Precision-Recall Curve
    precision, recall, _ = precision_recall_curve(y_test, mean_preds)
    plt.figure(figsize=(8, 6))
    plt.plot(recall, precision, label="Precision-Recall Curve")
    plt.xlabel("Recall")
    plt.ylabel("Precision")
    plt.title("Precision-Recall Curve")
    plt.legend(loc="best")
    plt.show()
    
    # Histogram of mean predictions
    plt.figure(figsize=(8, 6))
    plt.hist(mean_preds, bins=20, alpha=0.7, edgecolor='black')
    plt.xlabel("Predicted Probability")
    plt.ylabel("Frequency")
    plt.title("Distribution of Mean Predictions")
    plt.show()

######################
# MAIN: TRAINING & EVALUATION OF ALL MODELS
######################
# Ground truth labels as numpy array for evaluation
y_test_np = y_test_tensor.squeeze().detach().cpu().numpy()

# ---- 1. BNN using KL Divergence ----
print("Training BNN_KL...")
bnn_kl = BNN_KL(input_dim=X_train_tensor.shape[1], hidden_dim=20, output_dim=1)
bnn_kl = train_model(bnn_kl, nn.BCELoss(), X_train_tensor, y_train_tensor, 
                     epochs=200, lr=0.01, beta=0.01, reg_fn=bnn_kl.kl_divergence)
print("Evaluating BNN_KL:")
evaluate_model(bnn_kl, X_test_tensor, y_test_np, n_samples=100, stochastic=True)


# ---- 2. BNN using α-Divergence ----
print("\nTraining BNN_Alpha...")
bnn_alpha = BNN_Alpha(input_dim=X_train_tensor.shape[1], hidden_dim=20, output_dim=1)
bnn_alpha = train_model(bnn_alpha, nn.BCELoss(), X_train_tensor, y_train_tensor, 
                        epochs=200, lr=0.01, beta=0.01, reg_fn=lambda: bnn_alpha.alpha_div(alpha=0.5))
print("Evaluating BNN_Alpha:")
evaluate_model(bnn_alpha, X_test_tensor, y_test_np, n_samples=100, stochastic=True)


# ---- 3. Monte Carlo Dropout Network ----
print("\nTraining MC Dropout NN...")
mc_model = MCDropoutNN(input_dim=X_train_tensor.shape[1], hidden_dim=20, output_dim=1, p=0.5)
mc_model = train_model(mc_model, nn.BCELoss(), X_train_tensor, y_train_tensor, 
                       epochs=200, lr=0.01)
print("Evaluating MC Dropout NN:")
evaluate_model(mc_model, X_test_tensor, y_test_np, n_samples=100, stochastic=True)


# ---- 4. Deterministic Simple Neural Network ----
print("\nTraining Simple NN...")
simple_nn = SimpleNN(input_dim=X_train_tensor.shape[1], hidden_dim=20, output_dim=1)
simple_nn = train_model(simple_nn, nn.BCELoss(), X_train_tensor, y_train_tensor, 
                        epochs=200, lr=0.01)
print("Evaluating Simple NN (Deterministic):")
evaluate_model(simple_nn, X_test_tensor, y_test_np, n_samples=1, stochastic=False)
