import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _priceController;
  String _selectedCondition = 'Good';
  bool _isSaving = false;
  String? _errorMessage;

  final List<String> _conditions = ['Excellent', 'Good', 'Fair', 'Poor'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _priceController = TextEditingController(
      text: widget.book?.price.toString() ?? '',
    );
    _selectedCondition = widget.book?.condition ?? 'Good';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final book = Book(
      id: widget.book?.id,
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      condition: _selectedCondition,
      price: double.parse(_priceController.text.trim()),
    );

    final provider = context.read<BookProvider>();
    bool success;

    if (widget.book == null) {
      success = await provider.addBook(book);
    } else {
      success = await provider.updateBook(widget.book!.id!, book);
    }

    setState(() {
      _isSaving = false;
    });

    if (success && mounted) {
      Navigator.pop(context, true);
    } else if (mounted) {
      setState(() {
        _errorMessage = 'Failed to save book. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

    // Show error if there is one
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Book' : 'Add Book'),
          centerTitle: true,
        ),
        body: ErrorMessageWidget(
          message: _errorMessage!,
          onRetry: _saveBook,
        ),
      );
    }

    // Show loading while saving
    if (_isSaving) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Book' : 'Add Book'),
          centerTitle: true,
        ),
        body: const LoadingWidget(),
      );
    }

    // Show form
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Book' : 'Add Book'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Book Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter author name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  border: OutlineInputBorder(),
                ),
                items: _conditions.map((condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveBook,
                  child: Text(isEditing ? 'UPDATE BOOK' : 'ADD BOOK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
