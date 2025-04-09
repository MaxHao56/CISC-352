import pandas as pd
import os
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__),'..','..')))
from env import *

def load_data():
    file_path = CANCER_DATA_FILE
    df = pd.read_csv(file_path)
    df.drop(columns=['id'], inplace=True, errors='ignore')
    df.drop(columns=['Unnamed: 32'], inplace=True, errors='ignore')
    X = df.drop(columns=['diagnosis'])

    return X, X.columns.tolist()
