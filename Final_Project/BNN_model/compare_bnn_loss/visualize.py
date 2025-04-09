import matplotlib.pyplot as plt

# def plot_loss_curves(kl_losses, alpha_losses, mc_losses):
#     plt.figure(figsize=(10, 6))
#     plt.plot(kl_losses, label="BNN (KL Divergence)", linewidth=2)
#     plt.plot(alpha_losses, label="BNN (α-Divergence)", linewidth=2)
#     plt.plot(mc_losses, label="MC Dropout", linewidth=2)
#     plt.xlabel("Epochs")
#     plt.ylabel("Loss")
#     plt.title("Training Loss Comparison")
#     plt.legend()
#     plt.grid(True)
#     plt.tight_layout()
#     plt.show()


## This plots the different loss curves using different optimizers
def plot_multiple_losses(loss_dict, title="Loss Comparison"):
    plt.figure(figsize=(10, 6))
    for label, losses in loss_dict.items():
        plt.plot(losses, label=label)
    plt.xlabel("Epochs")
    plt.ylabel("Loss")
    plt.title(title)
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()
