# 🇷🇼 Kigali City Directory

A real-time, full-stack mobile application for discovering and mapping essential services in Kigali, Rwanda. Built solo using **Flutter**, **Firebase**, and **Google Maps API**.



## 🚀 Overview
The Kigali City Directory is a centralized platform designed to solve the problem of finding verified local services. It features a reactive search engine, category-based filtering, and a synchronized map view, all powered by a serverless backend.

### Key Features
* **Real-time Synchronization:** Leverages Firestore Streams to update the UI instantly as the database changes.
* **Unified Search:** A responsive search bar that filters listings by name and address in real-time using the Provider pattern.
* **Geographic Discovery:** Integrated Google Maps with custom markers that automatically sync with filtered search results.
* **Secure Environment:** Implementation of `.env` patterns to keep API keys out of version control, using Gradle placeholders for Android injection.
* **Dynamic Contributions:** A dedicated workflow for users to add new listings, complete with automatic server-side timestamps.

---

## 🛠 Tech Stack
* **Frontend:** Flutter (Dart)
* **State Management:** Provider
* **Backend:** Google Firebase (Cloud Firestore)
* **Maps:** Google Maps Platform (Android/iOS)
* **Security:** Flutter Dotenv

---

## 🏗 Architectural Decisions

### 1. The Service-Layer Pattern
To maintain a clean codebase, I separated business logic from the UI. The `FirestoreService` handles all raw database interactions, while the `ListingsProvider` manages the application state. This makes the app scalable and easier to debug.

### 2. Zero-Latency Filtering
Rather than making expensive API calls for every keystroke, the app pulls a single stream from Firestore. The filtering logic happens in-memory within the Provider, providing a "search-as-you-type" experience with 0ms lag.

### 3. Native Platform Bridging
A significant technical challenge was securing the Google Maps API key while allowing the Android Manifest to access it. I implemented a custom `build.gradle` script that tunnels variables from a `.env` file into the `AndroidManifest.xml` during the build process.



---

## 📥 Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/yourusername/kigali_directory.git](https://github.com/yourusername/kigali_directory.git)
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Environment Variables:**
    Create a `.env` file in the root directory:
    ```env
    MAPS_API_KEY=your_google_maps_key_here
    ```

4.  **Native Android Config:**
    Ensure your `android/app/build.gradle` is configured to read from the `.env` file to populate `manifestPlaceholders`.

5.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 👨‍💻 Author
**Hamsee**
* Software Engineering & Data Science Student.
* Specializing in Python, Flutter, Go, and "under the hood" implementations.

---
