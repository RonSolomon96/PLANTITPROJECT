import datetime
from email.message import EmailMessage
import pyrebase
import firebase_admin
import threading
import socket
from firebase_admin import credentials
from firebase_admin import firestore
from flask import Flask, request, jsonify
import uuid
import smtplib
import ssl


# Initialize pyrebase with user credentials
config = {
    'apiKey': "AIzaSyCRaKSS_ANuUa1QibLkWuntJ135EYK9CXY",
    'authDomain': "plantitdb1.firebaseapp.com",
    'projectId': "plantitdb1",
    'storageBucket': "plantitdb1.appspot.com",
    'messagingSenderId': "959335294179",
    'appId': "1:959335294179:web:21f768d3aab7a7c5b191d6",
    'measurementId': "G-JNXM9WXHXZ",
    'databaseURL': ''}

firebase = pyrebase.initialize_app(config)
# Use pyrebase to authenticate users
auth = firebase.auth()
storage = firebase.storage()

# Initialize firebase_admin with service account credentials
cred = credentials.Certificate("plantitdb1-firebase-adminsdk-y2grh-c4930ddb02.json")
firebase_admin.initialize_app(cred)

# Use firebase_admin to perform administrative tasks, such as managing user accounts or accessing the Cloud Firestore
# database
db = firestore.client()

email_sender = 'plantit2023biu@gmail.com'
email_password = 'wcdcglpbprvlzaey'
em = EmailMessage()
em['From'] = email_sender
em["Subject"] = "Water level update!"
context = ssl.create_default_context()
smtp = smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context)
smtp.login(email_sender, email_password)

# Initialize Flask app
app = Flask(__name__)


# Firebase Authentication
@app.route('/register', methods=['POST'])
def register():
    """
    Register a new user with the given email and password.
    """
    data = request.get_json()
    email = data['email']
    password = data['password']
    username = data['username']
    try:
        # get user
        user = auth.create_user_with_email_and_password(email=email, password=password)
        print(user)
        auth.update_profile(
            user['idToken'],
            display_name=username
        )
        # insert data to db
        data1 = {}
        user_ref = db.collection('users').document(data['email'])
        data1['email'] = data['email']
        data1['username'] = data['username']
        user_ref.set(data1)
        return jsonify(user), 201
    except Exception as e:
        error_message = str(e)
        print(error_message)
        return jsonify({"message": f"Unable to create user. Reason: {error_message}"}), 400


@app.route('/login', methods=['POST'])
def login():
    """
    Log in a user with the given email and password.
    """
    data = request.get_json()
    email = data['email']
    password = data['password']
    try:
        user = auth.sign_in_with_email_and_password(email, password)
        return jsonify({"message": "Login successful."}), 200
    except:
        return jsonify({"message": "Invalid email or password."}), 400


@app.route('/resetPass', methods=['POST'])
def reset():
    """
    Reset password of user.
    """
    data = request.get_json()
    email = data['email']
    try:
        auth.send_password_reset_email(email)
        return jsonify({"message": "reset successful."}), 201
    except:
        return jsonify({"message": "Invalid email."}), 400


@app.route('/users', methods=['GET'])
def read_users():
    """
    Retrieve all users from Firestore DB.
    """
    users = [doc.to_dict() for doc in db.collection('users').stream()]
    return jsonify(users), 200


@app.route('/users/<user_id>', methods=['GET'])
def read_user(user_id):
    """
    Retrieve a specific user by ID from Firestore DB.
    """
    user_doc = db.collection('users').document(user_id).get()
    if user_doc.exists:
        return jsonify(user_doc.to_dict()), 200
    else:
        return jsonify({"message": "User not found."}), 404


@app.route('/users/<user_id>', methods=['PUT'])
def update_user(user_id):
    """
    Update a specific user by ID with the given data.
    """
    data = request.get_json()
    user_ref = db.collection('users').document(user_id)
    user_ref.update(data)
    return jsonify({"message": "User updated successfully."}), 200


@app.route('/users', methods=['DELETE'])
def delete_user():
    """
    Delete a specific user by ID from Firestore DB.
    """
    user_id = request.args.get('user_id')
    token = request.args.get('token')
    user_ref = db.collection('users').document(user_id)
    user_ref.delete()
    auth.delete_user_account(token)
    return jsonify({"message": "User deleted successfully."}), 200


@app.route('/deletePlant', methods=['DELETE'])
def delete_plant():
    user1 = request.args.get('user')
    plant = request.args.get('plant')
    user = db.collection('users').document(user1)

    # Delete the specific plant from User_Plants collection
    plant_docs = user.collection("User_Plants").where("nickname", "==", plant).stream()
    plant_ref = None
    for doc in plant_docs:
        plant_ref = doc.reference
        break
    if plant_ref is None:
        return jsonify({"error": "Plant not found"}), 404

    # Delete subcollection
    subcollection_ref = plant_ref.collection("History")
    docs = subcollection_ref.stream()
    for doc in docs:
        doc.reference.delete()
    plant_ref.delete()
    # Check if the 'plants' array is empty
    sensor_docs = db.collection("Sensors").where("user", "==", user1).stream()
    sensor_ref = None
    plants_arr = []  # Initialize the variable with an empty list
    for doc in sensor_docs:
        sensor_data = doc.to_dict()
        plants_arr = sensor_data.get('plants', [])
        if plant in plants_arr:
            # Remove the specific plant from the 'plants' array
            plants_arr.remove(plant)
            sensor_data['plants'] = plants_arr
            sensor_ref = doc.reference
            sensor_ref.set(sensor_data)
            break

    # Delete the entire document if 'plants' array is empty
    if sensor_ref is not None and len(plants_arr) == 0:
        sensor_ref.delete()

    return jsonify({"message": "Successfully deleted"}), 201


@app.route('/addToGarden', methods=['POST'])
def add_to_garden():
    """
    add a new plant with the given data.
    """
    data = request.get_json()
    data["Water level"] = ""
    print(request.args.get('user'))

    p = db.collection('users').document(request.args.get('user'))
    p.collection("User_Plants").add(data)
    # get the sensor needed
    sensor_ref = db.collection('Sensors').document(request.args.get('sensornum'))
    sensor_data = sensor_ref.get().to_dict()

    if sensor_data and 'plants' in sensor_data:
        plants_arr = sensor_data['plants']
    else:
        plants_arr = []

    plants_arr.append(data["nickname"])

    sensor_ref.set({
        "user": request.args.get('user'),
        "plants": plants_arr,
        "sensornumber": request.args.get('sensornum')
    })

    return jsonify({"message": "Plant created successfully."}), 201


@app.route('/addToHistory', methods=['POST'])
def add_to_history():
    user1 = request.args.get('user')
    plant = request.args.get('plant')
    user = db.collection('users').document(user1)
    plant_docs = user.collection("User_Plants").where("nickname", "==", plant).stream()
    plant_ref = None
    for doc in plant_docs:
        plant_ref = doc.reference
        break
    if plant_ref is None:
        return jsonify({"error": "Plant not found"}), 404

    # Get the uploaded file
    file = request.files['image']
    # Generate a unique filename for the file
    filename = f'users/{user1}/{plant}/{uuid.uuid4().hex}.jpg'

    # Upload the file to Firebase Storage
    storage.child(filename).put(file)
    temp = len(plant_ref.collection('History').get())

    # Add the other form data to Firestore
    plant_ref.collection('History').add({
        'image': storage.child(filename).get_url(None),
        'serial': temp + 1,
        'date': request.form['date']
    })

    return jsonify({"message": "Successfully added to history"}), 201


@app.route('/plants', methods=['GET'])
def read_plants():
    """
    Retrieve all plants from Firestore DB.
    """
    p = [doc.to_dict() for doc in db.collection('Plants').stream()]
    return jsonify(p), 200


@app.route('/plants/<light>/<temp>/<moist>', methods=['GET'])
def read_plant(light, temp, moist):
    """
    Get specific plants from Firestore DB according to sensors data.
    """

    plant = [doc.to_dict() for doc in db.collection('Plants').where("Light", "==", light).
        where("Temperature", "==", temp).where("Humidity", "==", moist).stream()]
    # if plant.exists:
    return jsonify(plant), 200


@app.route('/plants/<user>', methods=['GET'])
def get_user_plants(user):
    plants = [doc.to_dict() for doc in db.collection('users').document(user).collection("User_Plants").stream()]
    return jsonify(plants), 200


@app.route('/sensors', methods=['GET'])
def get_sensors():
    sensors = [doc.to_dict() for doc in db.collection('Sensors').stream()]
    return jsonify(sensors), 200


@app.route('/history/<user>/<plant>', methods=['GET'])
def get_plant_history(user, plant):
    # get specific plant form a user
    plant_docs = db.collection('users').document(user).collection("User_Plants").where("nickname", "==", plant).stream()
    plant_ref = None
    for doc in plant_docs:
        plant_ref = doc.reference
        break
    if plant_ref is None:
        return jsonify({"error": "Plant not found"}), 404
    history = [doc.to_dict() for doc in plant_ref.collection("History").stream()]
    print(history)
    # return history list sorted by serial number
    sorted_history = sorted(history, key=lambda h: h["serial"])

    return jsonify(sorted_history[::-1]), 200


@app.route('/plants/<user>/<nickname>', methods=['GET'])
def get_user_plant(user, nickname):
    # get all user plants
    plant = [doc.to_dict() for doc in db.collection('users').document(user).collection("User_Plants").
        where("nickname", "==", nickname).stream()]
    return jsonify(plant[0]), 200


@app.route('/updateWaterLevel', methods=['POST'])
def update_water_level():
    user1 = request.args.get('user')
    plant = request.args.get('plant')
    user = db.collection('users').document(user1)

    # get the specific plant from User_Plants collection
    plant_docs = user.collection("User_Plants").where("nickname", "==", plant).stream()
    plant_ref = None
    for doc in plant_docs:
        plant_ref = doc.reference
        break
    if plant_ref is None:
        return jsonify({"error": "Plant not found"}), 404

    str = "Water level"
    # Update the "WaterLevel" field to "handled"
    plant_ref.set({str: "handled"}, merge=True)

    return jsonify({"message": "Water level updated"}), 200


def udp_listener():
    server_ip = '0.0.0.0'  # Listen on all available network interfaces
    server_port = 5002
    # init socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_address = (server_ip, server_port)
    sock.bind(server_address)

    while True:
        # get the messege from the sensors
        data, address = sock.recvfrom(1024)
        message = data.decode()
        pairs = message.split(":")
        print(message)
        current_time = datetime.datetime.now().time()
        hour = current_time.hour
        minute = current_time.minute
        second = current_time.second
        # send a response to the data base at 8 am and 19 pm
        if (hour == 8 and minute == 0 and 0 <= second <= 2) or (hour == 15 and minute == 58 and 0 <= second <= 2):
            print("update sensors data")
            sensor_doc = db.collection("Sensors").document(pairs[3])
            doc = sensor_doc.get()

            if doc.exists:
                # Document found
                sensor_data = doc.to_dict()
                user1 = sensor_data["user"]
                for p in sensor_data["plants"]:
                    user = db.collection('users').document(user1)
                    plant_docs = user.collection("User_Plants").where("nickname", "==", p).stream()
                    plant_ref = None
                    for doc in plant_docs:
                        plant_ref = doc.reference
                        break
                    # check for water level in the ground and update in db
                    plant_data = plant_ref.get().to_dict()

                    if int(pairs[1]) < 90:
                        plant_data["Water level"] = "1"
                    elif int(pairs[1]) < 180:
                        plant_data["Water level"] = "2"
                    else:
                        plant_data["Water level"] = "3"

                    plant_ref.set(plant_data)
                    if plant_data["Water level"] != plant_data["Water"]:

                        email = user.get().to_dict()['email']
                        em['To'] = email
                        body1 = f'You have a water level update in {plant_data["nickname"]}!\nplease check PlantIt App'
                        em.set_content(body1)
                        smtp.sendmail(email_sender, email, em.as_string())

            else:
                # Document does not exist
                print("prob...")


# Run Flask app
if __name__ == '__main__':
    # Start the UDP listener thread
    udp_thread = threading.Thread(target=udp_listener)
    udp_thread.start()
    app.run(debug=True, host='0.0.0.0')
