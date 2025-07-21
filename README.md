# Flutter Employee Management App

A Flutter app for managing employees, tasks, and attendance, supporting persistent storage and running on both Android and Web.

---

## 🚀 Features

- Add, update, and view employee tasks
- Set task name, due date, priority, and status
- Attendance tracking with persistent history
- Data saved locally using SharedPreferences
- Responsive UI for Android and Web
- Form validation and error messages
- Refresh and clear history options

---

##  Tools & Packages Used

- **[Flutter](https://flutter.dev/):** The main framework for building cross-platform apps.
- **[shared_preferences](https://pub.dev/packages/shared_preferences):** For local data persistence, so tasks and attendance are saved across app restarts.
- **[google_fonts](https://pub.dev/packages/google_fonts):** For custom fonts and improved UI appearance.


**Why these packages?**
- `shared_preferences` is lightweight and perfect for simple key-value storage.
- `google_fonts` makes it easy to use beautiful, readable fonts.


---

##  How to Run

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)
- Android Studio or VS Code (recommended)
- For web: Chrome or any modern browser

---

### Running on Android

1. **Connect your Android device** or start an emulator.
2. **In your project directory, run:**
   
   flutter pub get
   flutter run
   
   This will launch the app on your connected device or emulator.

3. **To build an APK:**
   
   flutter build apk
   
   The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

---

###  Running on Web

1. **Make sure you have Chrome installed.**
2. **In your project directory, run:**
   
   flutter pub get
   flutter run -d chrome
   
   This will launch the app in your default browser.

3. **To build for deployment:**
   
   flutter build web
   
   The web build will be in `build/web/`.

---



##  Project Structure

```
lib/
  main.dart
  screens/
    home.dart
    task_screen.dart
    attendence_screen.dart
  models/
    task.dart
    employee.dart


##  Bonus Features..
    Refresh Feature
    The Refresh button in both the Attendance and Tasks screens allows users to reload the latest data from persistent storage (SharedPreferences).

    
    Attendance History
    The Attendance History section displays a list of incomplete attendance records of employees

    
    Tasks History
    The Tasks History section (in your task management screen) lists all tasks that have been added:
    Each task displays its name, due date, priority, and status.

##  Development Time

This app was developed in **1 day**.
    
    



**Made with Flutter **