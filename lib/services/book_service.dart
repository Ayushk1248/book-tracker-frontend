import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookService {
  final String baseUrl = "http://localhost:8081/books";

  // Get the saved token from storage
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 1. Fetch all books
  Future<List<dynamic>> getBooks() async {
    String? token = await _getToken();
    
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Send the token!
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load books");
    }
  }

  // 2. Add a new book
  Future<void> addBook(String title, String author, String status) async {
    String? token = await _getToken();

    await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": title,
        "author": author,
        "status": status,
      }),
    );
  }

  // 3. Delete a book
  Future<void> deleteBook(int id) async {
    String? token = await _getToken();
    
    await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}