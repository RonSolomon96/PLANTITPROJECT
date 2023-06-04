import sys
import requests
import pytest
from datetime import datetime

user_token = ''


def check_sign_up(url):
    global user_token
    """
    Function purpose - check if the sign up of function works in server side at /register
    """
    # user already exist
    payload = {"username": "ron", "password": "Rs123456", "email": "rsalomon230@gmail.com"}
    headers = {'Content-Type': 'application/json'}
    res = requests.post(url + "/register", json=payload, headers=headers)
    assert res.status_code == 400

    # user sign up successfully
    payload = {"username": "testUsername", "password": "testPass", "email": "testEmail@gmail.com"}
    res = requests.post(url + "/register", json=payload, headers=headers)
    assert res.status_code == 201
    user_token = res.json().get('idToken')



def check_sign_in(url):
    url = url + '/login'
    """
    Function purpose - check if the sign in function works in server side at /login
    """
    # negative tests - user does not exist
    users = [("Ron@gmail.com", "1234"), ("ort", "aaaa"), ("abc@gmail.com", "Ra123456"), ("rsalo@gmail.com", "Ra123456")]
    payload = {"email": None, "password": None}
    headers = {'Content-Type': 'application/json'}

    for pair in users:
        payload["email"] = pair[0]
        payload["password"] = pair[1]
        res = requests.post(url, json=payload, headers=headers)
        assert res.status_code == 400

    # positive test -  exist
    payload = {"password": "testPass", "email": "testEmail@gmail.com"}
    res = requests.post(url, json=payload, headers=headers)
    assert res.status_code == 200

    # positive test -  exist (was created in previous test)
    payload = {"password": "testPass", "email": "testEmail@gmail.com"}
    res = requests.post(url, json=payload, headers=headers)
    assert res.status_code == 200


def check_add_plant(url):
    url = url + "/addToGarden?user=testEmail@gmail.com&&sensornum=100"
    """
    Function purpose - check for adding plant to user on server side at /addToGarden
    """

    # positive test - add new plant
    payload = {"Botanical Name": "Hippeastrum hybrids",
               "Common_name": "Amaryllis",
               "Description": "Amaryllis grows in African woodlands. "
                              "You can find this plant in Australia as well. "
                              "The blooms form on the bush before the leaf plates grow, "
                              "indicating that this is a bulbous plant with an average growth rate. "
                              "The amaryllis bulb has a life expectancy of about twenty years if it is properly cared for. "
                              "Bright red or red-white flowers are the most prevalent. "
                              "Pink, orange, yellow, green, purple, and even multi-colored flowers can be found in nature. "
                              "Some buds are composed of two flowers.",
               "Humidity": "2",
               "Image_url": "https://firebasestorage.googleapis.com/v0/b/plantitdb1.appspot.com/o/images%2FAmaryllis.jpg?alt=media",
               "Light": "2",
               "Soil": "1",
               "Temperature": "2",
               "Water": "2",
               "nickname": "NicknameTest"}

    headers = {'Content-Type': 'application/json'}
    res = requests.post(url, json=payload, headers=headers)
    assert res.status_code == 201


def check_add_history(url):
    url = url + "/addToHistory?user=testEmail@gmail.com&plant=NicknameTest"
    """
    Function purpose - check for adding history to plant on server side at /addToHistory
    """
    # Get the current date
    current_date = datetime.now().date()
    # Format the date as a string in a desired format
    formatted_date = current_date.strftime("%Y-%m-%d")

    files = {'image': open("flower.png", "rb")}
    data = {'date': formatted_date}

    res = requests.post(url, files=files, data=data)
    assert res.status_code == 201


def check_delete_plant(url):
    """
    Function purpose - check for deleting plant in server side at /deletePlant
    """
    # positive test - delete existing plant
    res = requests.delete(url + "/deletePlant?user=testEmail@gmail.com&plant=NicknameTest")
    assert res.status_code == 201

    # negative test - plant doesn't exist
    res = requests.delete(url + "/deletePlant?user=testEmail@gmail.com&plant=notReal")
    assert res.status_code == 404


def check_delete_user(url):
    url = url + "/users?user_id=testEmail@gmail.com&token=" + user_token

    """
    Function purpose - check for deleting user in server side at /users (delete)
    """
    res = requests.delete(url)
    assert res.status_code == 200


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 testServer.py [server url]")
        exit(1)
    print("Checking sign up")
    check_sign_up(sys.argv[1])
    print("Passed")
    print("Checking sign in")
    check_sign_in(sys.argv[1])
    print("Passed")
    print("Checking add plant")
    check_add_plant(sys.argv[1])
    print("Passed")
    print("Checking add history")
    check_add_history(sys.argv[1])
    print("Passed")
    print("Checking delete plant")
    check_delete_plant(sys.argv[1])
    print("Passed")
    print("Checking delete user")
    check_delete_user(sys.argv[1])
    print("Passed")
