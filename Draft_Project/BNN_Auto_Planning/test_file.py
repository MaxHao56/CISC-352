import requests
import json


# Define the URL for the Flask app
BASE_URL = 'http://127.0.0.1:5000'  # Adjust if your Flask app runs on a different host/port

# Sample data that mimics the input your API expects
test_data = {
    'actions': [
        "perimeter_hhh",  # Example action names
        "smoothness_hhh",
        "symmetry_hhh",
        "radius_hhh",
        "area_hhh"
    ]
}

def test_least_cost_plan():
    response = requests.post(f'{BASE_URL}/least_cost_plan', json=test_data)

    print("Request Payload:", json.dumps(test_data, indent=4))  # Print the payload
    print("Response Code:", response.status_code)  # Print status code
    print("Response Text:", response.text)  # Print response text

    if response.status_code == 200:
        print("Test Passed! Response:")
        print(json.dumps(response.json(), indent=4))
    else:
        print("Test Failed! Status Code:", response.status_code)
        print("Response:", response.text)

if __name__ == "__main__":
    test_least_cost_plan()

