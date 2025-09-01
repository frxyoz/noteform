# NoteForm – Piano Hand Posture Analysis App

**NoteForm** is a Flutter-based iOS application that provides **real-time feedback on piano hand posture** using machine learning. The app tracks user progress over time, helping pianists improve accuracy and technique through **data-driven insights**.

---

## Key Features

- **Real-Time Pose Analysis**  
  Uses Mediapipe machine learning to analyze piano hand posture with **95% accuracy**, providing immediate feedback on finger and hand positions.

- **Progress Tracking**  
  Firebase integration stores session data, allowing users to monitor improvement over time through **detailed history logs**.

- **Interactive Feedback**  
  Displays the number of hands detected, correct fingers, and correctly positioned hands for each practice session.

- **Cross-Platform Architecture**  
  Built in Flutter (Dart), enabling potential future expansion to **Android and web platforms**.

---

## System Architecture

### 1. Flutter App
- Serves as the **central hub** for capturing, processing, and displaying data.
- Sends camera snapshots to the **Flask server** for pose estimation, then receives processed feedback for display.
- Manages session data locally and synchronizes it with Firebase for **long-term storage**.

### 2. Firebase Database
- Handles **user authentication** and secure storage of emails and passwords.
- Stores processed session data, enabling users to **review past practice sessions** and track progress over time.
- Provides **real-time data synchronization** across sessions.

### 3. Pose Estimation Server
- Implemented in **Flask** and hosted on **Render**.
- Processes images from the Flutter app using **Mediapipe** for hand and finger pose estimation.
- Calculates correctness of finger positions by analyzing angles compared to **trained sample images**.
- Returns feedback to the app in real-time for immediate display to users.

---

## Screenshots

**Discover Page**  
<img src="/assets/DiscoverPageSC.png" alt="Discover Page" width="600"/>

**History Page**  
<img src="/assets/HistoryPageSC.png" alt="History Page" width="600"/>

---

## Technologies Used

- **Flutter (Dart):** Front-end app development  
- **Mediapipe:** Real-time hand pose estimation  
- **Firebase:** Authentication, Firestore database, storage  
- **Flask:** Server-side image processing and ML inference  
- **Render:** Hosting the Flask server

---
