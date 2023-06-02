import sys
import requests
import pytest


def check_sign_in(url):
    """
    Function purpose - check if the sign in function works in server side at /sign_in
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
    payload["email"] = "rsalomon230@gmail.com"
    payload["password"] = "Rs123456"
    res = requests.post(url, json=payload, headers=headers)
    assert res.status_code == 200


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 testServer.py [server url]")
        exit(1)
    print("Checking sign in")
    check_sign_in(sys.argv[1] + '/login')
    print("Passed")
