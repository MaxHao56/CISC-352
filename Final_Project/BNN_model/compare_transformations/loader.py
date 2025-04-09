import pandas as pd

def load_data():
    file_path = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/datasets/Cancer_Data.csv"
    df = pd.read_csv(file_path)
    df.drop(columns=['id'], inplace=True, errors='ignore')
    df.drop(columns=['Unnamed: 32'], inplace=True, errors='ignore')
    X = df.drop(columns=['diagnosis'])

    return X, X.columns.tolist()
