import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
import os
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from env import *
 


# making sure dataset is imported by adpating to other computers
file_path = CANCER_DATA_FILE

df = pd.read_csv(file_path)

# Drop unnecessary columns and encode diagnosis labels
df.drop(columns=['id', 'Unnamed: 32'], inplace=True, errors='ignore')
df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])  # Malignant=1, Benign=0

# Display basic statistics
print(df.describe())

# Check for missing values
print("\nMissing values:\n", df.isnull().sum())

# Correlation matrix
plt.figure(figsize=(14, 10))
sns.heatmap(df.corr(), annot=False, cmap='coolwarm', linewidths=0.5)
plt.title('Correlation Matrix')
plt.show()

# Feature distributions by diagnosis
features = df.columns[1:11]  # Selecting first 10 features for demonstration
for feature in features:
    plt.figure(figsize=(6, 4))
    sns.histplot(data=df, x=feature, hue='diagnosis', kde=True, bins=30)
    plt.title(f'Distribution of {feature} by Diagnosis')
    plt.xlabel(feature)
    plt.ylabel('Frequency')
    plt.show()

# Feature Scaling
X = df.drop('diagnosis', axis=1)
y = df['diagnosis']
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

# Data ready for Bayesian Neural Network training
print("Training features shape:", X_train.shape)
print("Testing features shape:", X_test.shape)