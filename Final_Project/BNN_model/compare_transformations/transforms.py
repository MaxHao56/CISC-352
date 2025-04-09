import numpy as np
from sklearn.preprocessing import PowerTransformer

def apply_transformations(X):
    X_np = X.values.copy()

    # Yeo-Johnson
    yeo = PowerTransformer(method='yeo-johnson')
    X_yeo = yeo.fit_transform(X_np)

    # -log(x) Transform - add epsilon to avoid log(0)
    epsilon = 1e-6
    X_shifted = np.clip(X_np, epsilon, None)
    X_log = -np.log(X_shifted)

    return X_yeo, X_log, X_np
