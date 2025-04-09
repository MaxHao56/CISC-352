from data import load_data
from models import BNN_KL, BNN_Alpha, MCDropoutNN
from train import train_model
from evaluate import evaluate_model
from visualize import plot_loss_curves
import torch.nn as nn

def main():
    X_train, X_test, y_train, y_test = load_data()

    print("Training BNN_KL...")
    bnn_kl = BNN_KL(input_dim=X_train.shape[1], hidden_dim=20, output_dim=1)
    bnn_kl, kl_losses = train_model(
        bnn_kl, nn.BCELoss(), X_train, y_train,
        epochs=200, lr=0.01, beta=0.01, reg_fn=bnn_kl.kl_divergence
    )
    evaluate_model(bnn_kl, X_test, y_test, stochastic=True)

    print("\nTraining BNN_Alpha...")
    bnn_alpha = BNN_Alpha(input_dim=X_train.shape[1], hidden_dim=20, output_dim=1)
    bnn_alpha, alpha_losses = train_model(
        bnn_alpha, nn.BCELoss(), X_train, y_train,
        epochs=200, lr=0.1, beta=0.01, reg_fn=lambda: bnn_alpha.alpha_div(alpha=0.5)
    )
    evaluate_model(bnn_alpha, X_test, y_test, stochastic=True)

    print("\nTraining MC Dropout NN...")
    mc_model = MCDropoutNN(input_dim=X_train.shape[1], hidden_dim=20, output_dim=1, p=0.5)
    mc_model, mc_losses = train_model(
        mc_model, nn.BCELoss(), X_train, y_train,
        epochs=200, lr=0.01
    )
    evaluate_model(mc_model, X_test, y_test, stochastic=True)

    plot_loss_curves(kl_losses, alpha_losses, mc_losses)

if __name__ == "__main__":
    main()
