import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'add_edit_book_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load books when screen opens
    context.read<BookProvider>().fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Exchange'),
        centerTitle: true,
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          // Loading - USING your LoadingWidget
          if (bookProvider.isLoading && bookProvider.books.isEmpty) {
            return const LoadingWidget();
          }

          // Error - USING your ErrorMessageWidget
          if (bookProvider.errorMessage != null) {
            return ErrorMessageWidget(
              message: bookProvider.errorMessage!,
              onRetry: () => bookProvider.fetchBooks(),
            );
          }

          // Empty
          if (bookProvider.books.isEmpty) {
            return const Center(
              child: Text('No books. Tap + to add'),
            );
          }

          // List of books
          return ListView.builder(
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              final book = bookProvider.books[index];
              return BookCard(
                book: book,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditBookScreen(book: book),
                    ),
                  ).then((_) {
                    bookProvider.fetchBooks();
                  });
                },
                onDelete: () {
                  bookProvider.deleteBook(book.id!);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditBookScreen(),
            ),
          ).then((_) {
            context.read<BookProvider>().fetchBooks();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
