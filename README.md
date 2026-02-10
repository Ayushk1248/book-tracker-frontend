Book Tracker Frontend (Flutter)

1. Project Overview
Most book apps look boring, so I decided to make this one beautiful. I built a modern, responsive web application using Flutter that features a "Glassmorphism" design—think frosted glass effects and smooth animations. It connects to my Spring Boot backend to let users manage their library in style.

2. Technology Stack
- Flutter SDK for the UI magic.
- Dart as the programming language.
- HTTP Package to talk to the backend.
- Shared Preferences to save the user's login session locally.

3. Setup Guide
Let's get this running on your browser.
First, make sure you have the Flutter SDK installed and your backend is running on port 8081.
Second, open this folder in your terminal and run "flutter pub get" to download the dependencies.
Third, type "flutter run -d chrome" and watch the app launch in your browser.

4. Explanation of the Folder Structure
- lib/screens: Contains the visual pages like the Login and Home screens.
- lib/services: The invisible workers that fetch data from the backend.
- lib/main.dart: The starting point that sets up the theme and routing.

5. Screen Flow
The journey is simple and intuitive:
- Login Screen: A beautiful frosted glass card where users sign in.
- Home Screen: The main dashboard. Books slide in with animations, and you can see your collection at a glance.
- Search: I added a search bar in the top corner so you can filter books instantly by title or author.
- Add Book: A simple popup dialog to save new titles to your list.

6. API Integration Notes
The app uses a dedicated AuthService to handle the heavy lifting of logging in and storing tokens. For every other request (like getting or adding books), the app automatically attaches that secure token to the header, ensuring the backend knows exactly who is asking for the data.
