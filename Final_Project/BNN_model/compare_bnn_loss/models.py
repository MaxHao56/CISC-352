import torch
import torch.nn as nn
import torch.nn.functional as F

# ---- BNN KL ----
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

# ---- BNN Alpha ----
def alpha_divergence(q_mu, q_sigma, alpha=0.5):
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

# ---- MC Dropout ----
class MCDropoutNN(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim, p=0.5):
        super().__init__()
        self.fc1 = nn.Linear(input_dim, hidden_dim)
        self.dropout = nn.Dropout(p)
        self.fc2 = nn.Linear(hidden_dim, output_dim)

    def forward(self, x):
        x = F.relu(self.fc1(x))
        return torch.sigmoid(self.fc2(self.dropout(x)))
