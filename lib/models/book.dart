import 'package:flutter/material.dart';

class Book {
  final String? id;
  final String title;
  final String author;
  final String condition;
  final double price;

  Book({
    this.id,
    required this.author,
    required this.condition,
    required this.price,
    required this.title,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      author: json['author'] ?? 'Unknown Author',
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      condition: json['condition'] ?? 'Good',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'condition': condition,
      'price': price,
    };
  }
}
