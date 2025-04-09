import matplotlib.pyplot as plt
import numpy as np

def plot_distributions(X, feature_names, title, save_path=None):
    num_features = X.shape[1]
    plt.figure(figsize=(15, 10))
    for i in range(num_features):
        plt.subplot(5, 6, i + 1)
        plt.hist(X[:, i], bins=30, alpha=0.7)
        plt.title(feature_names[i], fontsize=8)
        plt.xticks(fontsize=6)
        plt.yticks(fontsize=6)
    plt.suptitle(title, fontsize=16)
    plt.tight_layout(rect=[0, 0.03, 1, 0.95])
    if save_path:
        plt.savefig(save_path)
    plt.show()
