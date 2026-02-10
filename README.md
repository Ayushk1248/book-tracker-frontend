# Book Tracker Frontend

## 1. Project Overview
A Flutter-based web application serving as the UI for the Book Tracker API. It features a modern "Glassmorphism" design, real-time search, and secure token management.

## 2. Technology Stack
* Flutter (Dart)
* HTTP Package (REST API)
* Shared Preferences (Local Storage)
* Google Fonts

## 3. Setup Guide
1. **Prerequisites:** Flutter SDK installed; Backend running on port 8081.
2. **Install:** Run `flutter pub get` to install dependencies.
3. **Run:** Execute `flutter run -d chrome`.

## 4. Explanation of Folder Structure
* `lib/screens`: UI pages (Login, Home).
* `lib/services`: API handling logic (AuthService, BookService).
* `lib/main.dart`: App entry point and theme config.

## 5. Screen Flow
1. **Login:** User authenticates; token is stored locally.
2. **Home:** Displays book list with a search bar for filtering.
3. **Add Book:** Modal dialog to input Title, Author, and Status.
4. **Logout:** Clears token and redirects to Login.

## 6. API Integration Notes
* **Networking:** Uses `http` package for all requests.
* **Auth:** `AuthService` manages login and token storage.
* **Security:** `BookService` automatically attaches the JWT to the `Authorization` header for all protected API calls.
