
# PLANIT - Smart Plant Care System

PLANIT is an IoT-enabled mobile application designed to help users grow and care for plants more easily. The system uses Arduino sensors, a Flutter-based mobile app, and a Flask backend with Firebase to give real-time feedback and recommendations on plant growth conditions.


## Architecture Overview

- Client Layer: Mobile application built in Flutter
- Server Layer: Lightweight Flask server for backend logic
- Database Layer: Firebase for authentication and plant data storage
- Hardware Layer: Arduino with sensors for humidity, temperature, light, and water level

---

## Core Features

1. User Authentication
   - Sign up / log in / password recovery via Firebase

2. Plant Information
   - View data about various plant species

3. Smart Plant Monitoring
   - Sensors collect environmental data in real time

4. Personal Garden Dashboard
   - Users track and update status of their plants

5. Plant Recommendation
   - Based on collected sensor data and user location

6. Photo Updates
   - Users can upload photos and receive insights

---

## Technologies Used

| Layer            | Tech Stack                                 |
|------------------|---------------------------------------------|
| Client           | Flutter                                     |
| Server           | Flask (Python)                              |
| Database         | Firebase (Authentication + Firestore)       |
| Hardware         | Arduino + NodeMCU + Humidity/Light Sensors  |

---

## Basic Flow

1. Sign Up / Log In
2. Add New Plant → Sample area via sensors → Get plant suggestions
3. Choose Plant → Add to garden → Track history
4. Update Plant → Take photo → Get care insights
5. View Info → Browse all plant types and tips

---

## Sensor Layer (NodeMCU + Arduino)

- Measures humidity, light, temperature, and water level
- Sends data to Firebase via Wi-Fi
- Enables data-driven plant recommendations

---

## Firebase Features

- Realtime database for plant tracking
- Cloud storage for photo uploads
- Authentication for secure user access

---
