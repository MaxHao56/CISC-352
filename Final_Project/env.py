# env.py

import os

# Base directory 
BASE_DATA_DIR = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/datasets/Cancer_Data.csv"
PLANNING_DOMAIN_DIR = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/BNN_Auto_Planning/CancerCheck_BNN_domain.pddl"
PLANNING_PROBLEM_DIR = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/BNN_Auto_Planning/CancerCheck_BNN_Problem.pddl"
PLANNING_PROBLEM_OUTPUT_DIR = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/BNN_Auto_Planning/CancerCheck_BNN_Problem1.pddl"

# Specific file paths
CANCER_DATA_FILE = os.path.join(BASE_DATA_DIR)
PLANNING_PROBLEM_FILE = os.path.join(PLANNING_PROBLEM_DIR)
PLANNING_PROBLEM_OUTPUT_FILE = os.path.join(PLANNING_PROBLEM_OUTPUT_DIR)

# Add more as needed
# ANOTHER_DATA_FILE = os.path.join(BASE_DATA_DIR, "Other_File.csv")
