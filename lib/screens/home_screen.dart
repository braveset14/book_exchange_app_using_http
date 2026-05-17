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
    // Load 15 books from api when screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().fetchBooks();
    });
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
          // Loading - USING my custom LoadingWidget.
          if (bookProvider.isLoading && bookProvider.books.isEmpty) {
            return const LoadingWidget();
          }

          // USING my custom  ErrorMessageWidget.
          if (bookProvider.errorMessage != null) {
            return ErrorMessageWidget(
              message: bookProvider.errorMessage!,
              onRetry: () => bookProvider.fetchBooks(),
            );
          }

          if (bookProvider.books.isEmpty) {
            return const Center(
              child: Text('No books. Tap + to add'),
            );
          }

          // Lists all available books from api and ones created by user.
          return ListView.builder(
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              final book = bookProvider.books[index];
              return BookCard(
                book: book,
                onEdit: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditBookScreen(book: book),
                    ),
                  );
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
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddEditBookScreen(),
              ),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}
