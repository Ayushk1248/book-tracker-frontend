import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(BookTrackerApp());
}

class BookTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}