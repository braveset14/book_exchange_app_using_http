import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String endpoint = '/posts';

  // Function to create book

  Future<Book> createBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(book.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Book(
          id: responseData['id'],
          title: book.title,
          author: book.author,
          condition: book.condition,
          price: book.price,
        );
      } else {
        throw Exception('Failed to create book');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  //Function to get all books
  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint?_limit=15'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Function to update books.
  Future<Book> updateBook(int id, Book book) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(book.toJson()),
      );

      if (response.statusCode == 200) {
        return Book(
          id: id,
          title: book.title,
          author: book.author,
          condition: book.condition,
          price: book.price,
        );
      } else {
        throw Exception('Failed to update book');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Function to delete a book.
  Future<void> deleteBook(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint/$id'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete book');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
