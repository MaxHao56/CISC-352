import torch
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import accuracy_score, confusion_matrix

def evaluate_model(model, X_test, y_test, stochastic=True, n_samples=100):
    model.train() if stochastic else model.eval()
    preds = []
    for _ in range(n_samples if stochastic else 1):
        with torch.no_grad():
            out = model(X_test)
            preds.append(out.cpu().numpy())
    preds = np.stack(preds)
    mean_preds = preds.mean(axis=0).flatten()
    y_true = y_test.cpu().numpy().flatten()
    y_pred = (mean_preds >= 0.5).astype(int)

    print("Accuracy: {:.4f}".format(accuracy_score(y_true, y_pred)))
    print("Confusion Matrix:\n", confusion_matrix(y_true, y_pred))
