import pandas as pd
import torch
from sklearn.preprocessing import PowerTransformer, LabelEncoder
from sklearn.model_selection import train_test_split

def load_data():
    file_path = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/datasets/Cancer_Data.csv"
    df = pd.read_csv(file_path)

    df.drop(columns=['id', 'Unnamed: 32'], inplace=True, errors='ignore')
    df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])

    X = df.drop(columns=['diagnosis']).values
    y = df['diagnosis'].values

    X = PowerTransformer(method='yeo-johnson').fit_transform(X)
    X = torch.tensor(X, dtype=torch.float32)
    y = torch.tensor(y, dtype=torch.float32).unsqueeze(1)

    return train_test_split(X, y, test_size=0.3, random_state=42)
