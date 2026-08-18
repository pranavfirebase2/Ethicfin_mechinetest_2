# EthicFin Task Manager (Machine Test)

A Flutter task management application built for the EthicFin machine test. It uses Firebase Firestore for cloud storage and Hive for local offline support.

## Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (`AsyncNotifier`)
- **Local Storage:** Hive
- **Database:** Firebase Cloud Firestore
- **Network Check:** `connectivity_plus`

## Features
- Create, read, update, and delete tasks.
- Mark tasks as completed or pending.
- Offline-first approach: Tasks are saved locally first, then synced to Firebase.
- Auto-sync: Automatically uploads pending tasks to Firebase when the internet connection comes back.
- Local search by task title and description.
- Filter tasks by completion status (All, Completed, Pending).
- Sort tasks by Latest, Due Date, or Priority.

## How to Run

1. Clone the repository:
   ```bash
   git clone <your-repo-link>
   cd ethicfin_mechinetest_2
   ```

2. Get packages:
   ```bash
   flutter pub get
   ```

3. Setup Firebase:
   - Ensure your Firebase project is connected. 
   - `firebase_options.dart` is already included for the current configuration.

4. Run the app:
   ```bash
   flutter run
   ```

## Architecture

The app follows a Clean Architecture approach:
- **Presentation Layer:** Contains UI screens and Riverpod providers for state management.
- **Domain Layer:** Contains the `Task` model with serialization.
- **Data Layer:** 
  - `LocalTaskService`: Handles Hive operations.
  - `RemoteTaskService`: Handles Firebase operations.
  - `TaskRepository`: Manages data flow. Saves data to Hive first, then pushes to Firebase. Handles background syncing when offline.
