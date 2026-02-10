import 'package:flutter/material.dart';
import '../services/book_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookService _bookService = BookService();
  
  List<dynamic> _allBooks = [];      // Stores the full list from database
  List<dynamic> _filteredBooks = []; // Stores the list currently shown (filtered by search)
  
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
    // Listen to text changes to filter in real-time
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter books based on search text
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBooks = _allBooks.where((book) {
        String title = book['title'].toString().toLowerCase();
        String author = book['author'].toString().toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    });
  }

  void _loadBooks() async {
    try {
      var books = await _bookService.getBooks();
      setState(() {
        _allBooks = books;
        _filteredBooks = books; // Initially, show everything
      });
    } catch (e) {
      print("Error loading books: $e");
    }
  }

  void _showAddBookDialog() {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    String statusValue = "Reading";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text("Add New Book", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _darkTextField(titleController, "Title"),
            SizedBox(height: 10),
            _darkTextField(authorController, "Author"),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: statusValue,
              dropdownColor: Colors.grey.shade800,
              style: TextStyle(color: Colors.white),
              items: ["Reading", "Completed", "Wishlist"]
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) => statusValue = val!,
              decoration: InputDecoration(
                labelText: "Status",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black),
            onPressed: () async {
              if (titleController.text.isNotEmpty && authorController.text.isNotEmpty) {
                await _bookService.addBook(titleController.text, authorController.text, statusValue);
                Navigator.pop(context);
                _loadBooks(); // Refresh list
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _darkTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == "Completed") return Colors.greenAccent;
    if (status == "Reading") return Colors.blueAccent;
    return Colors.orangeAccent;
  }

  Color _getBookColor(int index) {
    List<Color> colors = [Colors.blueAccent, Colors.purpleAccent, Colors.orangeAccent, Colors.pinkAccent];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // SEARCH BAR LOGIC IN APP BAR
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Search title or author...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              )
            : Text("My Collection", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white70),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  // Clear search when closing
                  _searchController.clear();
                  _filteredBooks = _allBooks;
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen())),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.indigo.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _filteredBooks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu_book, size: 80, color: Colors.white24),
                    SizedBox(height: 10),
                    Text(
                      _allBooks.isEmpty ? "Your library is empty." : "No matching books found.",
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.fromLTRB(16, 100, 16, 20),
                itemCount: _filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = _filteredBooks[index];
                  // Animated List Item
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOutQuart,
                    builder: (context, double val, child) {
                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - val)),
                        child: Opacity(
                          opacity: val,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                            ),
                            child: Row(
                              children: [
                                // Colorful Book Icon
                                Container(
                                  height: 60, width: 45,
                                  decoration: BoxDecoration(
                                    color: _getBookColor(index),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [BoxShadow(color: _getBookColor(index).withOpacity(0.4), blurRadius: 8)],
                                  ),
                                  child: Icon(Icons.book, color: Colors.white.withOpacity(0.8)),
                                ),
                                SizedBox(width: 16),
                                // Text Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(book['title'], style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 4),
                                      Text(book['author'], style: TextStyle(color: Colors.white70, fontSize: 14)),
                                    ],
                                  ),
                                ),
                                // Status & Delete
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(book['status']).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: _getStatusColor(book['status']).withOpacity(0.5)),
                                      ),
                                      child: Text(book['status'], style: TextStyle(color: _getStatusColor(book['status']), fontSize: 12)),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, color: Colors.white30),
                                      onPressed: () async {
                                        await _bookService.deleteBook(book['id']);
                                        _loadBooks(); // Refresh list
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBookDialog,
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
        elevation: 10,
        icon: Icon(Icons.add),
        label: Text("ADD BOOK", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}