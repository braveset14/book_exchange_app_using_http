import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class BookProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Book> _books = [];
  bool _isLoading = false;
  String? _errorMessage;

  // These are getters to access data

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // This function fetches all books and notifies listners.
  Future<void> fetchBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _books = await _apiService.fetchBooks();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // This function adds a new book and notifies any listners.
  Future<bool> addBook(Book book) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newBook = await _apiService.createBook(book);
      _books.insert(0, newBook);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // This function  edits an existing book and notifies any listners.
  Future<bool> updateBook(String id, Book updatedBook) async {
    _isLoading = true;
    notifyListeners();

    try {
      final book = await _apiService.updateBook(id, updatedBook);
      final index = _books.indexWhere((book) => book.id == id);
      if (index != -1) {
        _books[index] = book;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // This function removes a book and notify listners.
  Future<bool> deleteBook(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteBook(id);
      _books.removeWhere((book) => book.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
