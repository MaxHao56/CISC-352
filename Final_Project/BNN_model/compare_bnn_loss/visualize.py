import matplotlib.pyplot as plt

def plot_loss_curves(kl_losses, alpha_losses, mc_losses):
    plt.figure(figsize=(10, 6))
    plt.plot(kl_losses, label="BNN (KL Divergence)", linewidth=2)
    plt.plot(alpha_losses, label="BNN (α-Divergence)", linewidth=2)
    plt.plot(mc_losses, label="MC Dropout", linewidth=2)
    plt.xlabel("Epochs")
    plt.ylabel("Loss")
    plt.title("Training Loss Comparison")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()
