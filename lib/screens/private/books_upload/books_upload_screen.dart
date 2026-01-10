import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:silsila_e_azeemia_dashboard/services/book_service.dart';
import 'package:silsila_e_azeemia_dashboard/widgets/private_scaffold.dart';

import 'package:silsila_e_azeemia_dashboard/model/book_schema.dart';

class BooksUploadScreen extends StatefulWidget {
  static const String routeName = '/books_upload';

  const BooksUploadScreen({super.key});

  @override
  State<BooksUploadScreen> createState() => _BooksUploadScreenState();
}

class _BooksUploadScreenState extends State<BooksUploadScreen> {
  final List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isFormVisible = false;
  int? _editingIndex;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pagesController = TextEditingController();
  final _yearController = TextEditingController();
  final _categoryController = TextEditingController();
  final _searchController = TextEditingController();

  final List<String> _authors = [
    'Khwaja Shamsuddin Azeemi',
    'Qalandar Baba Auliya',
    'Dr. Waqar Yousuf Azeemi',
    'Other',
  ];
  String? _selectedAuthor;
  XFile? _selectedImage;
  PlatformFile? _selectedBookFile;
  bool _isPurchaseRequired = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _filteredBooks = _books;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _filteredBooks = _books
          .where(
            (book) => book.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  void _toggleForm({int? index}) {
    setState(() {
      _isFormVisible = !_isFormVisible;
      if (_isFormVisible) {
        if (index != null) {
          _editingIndex = index;
          final book = _filteredBooks[index];
          final originalIndex = _books.indexOf(book);
          _editingIndex = originalIndex;

          _nameController.text = book.name;
          _pagesController.text = book.totalPages;
          _yearController.text = book.publishedYear;
          _categoryController.text = book.category;
          _selectedAuthor = _authors.contains(book.author) ? book.author : null;
          _selectedImage = book.image;
          _selectedBookFile = book.bookFile;
          _isPurchaseRequired = book.isPurchaseRequired;
        } else {
          _editingIndex = null;
          _nameController.clear();
          _pagesController.clear();
          _yearController.clear();
          _categoryController.clear();
          _selectedAuthor = null;
          _selectedImage = null;
          _selectedBookFile = null;
          _isPurchaseRequired = false;
        }
      }
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _pickBookFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedBookFile = result.files.first;
      });
    }
  }

  final BookService _bookService = BookService();

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final newBook = Book(
          name: _nameController.text,
          author: _selectedAuthor!,
          totalPages: _pagesController.text,
          publishedYear: _yearController.text,
          category: _categoryController.text,
          image: _selectedImage,
          bookFile: _selectedBookFile,
          isPurchaseRequired: _isPurchaseRequired,
        );

        if (_editingIndex != null) {
          // Edit logic (update API call if needed)
          _books[_editingIndex!] = newBook;
        } else {
          await _bookService.addBook(newBook);
          _books.add(newBook);
        }

        if (!mounted) return;
        Navigator.pop(context); // Close loader
        _onSearchChanged();
        _isFormVisible = false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Book added successfully')));
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close loader
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _deleteBook(int index) {
    final book = _filteredBooks[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_confirm_title'.tr()),
        content: Text('delete_confirm_msg'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel_btn'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _books.remove(book);
                _onSearchChanged();
              });
              Navigator.pop(context);
            },
            child: Text('action_delete'.tr()),
          ),
        ],
      ),
    );
  }

  void _viewBook(int index) {
    final book = _filteredBooks[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book.name),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (book.image != null)
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 100,
                    child: kIsWeb
                        ? Image.network(book.image!.path, fit: BoxFit.cover)
                        : Image.file(File(book.image!.path), fit: BoxFit.cover),
                  ),
                ),
              const SizedBox(height: 10),
              ListTile(
                title: Text('book_author_label'.tr()),
                subtitle: Text(book.author),
              ),
              ListTile(
                title: Text('book_pages_label'.tr()),
                subtitle: Text(book.totalPages),
              ),
              ListTile(
                title: Text('book_year_label'.tr()),
                subtitle: Text(book.publishedYear),
              ),
              ListTile(
                title: Text('book_category_label'.tr()),
                subtitle: Text(book.category),
              ),
              const Divider(),
              ListTile(
                title: Text('Download Status'),
                subtitle: Text(
                  book.bookFile == null
                      ? 'coming_soon'.tr()
                      : book.isPurchaseRequired
                      ? 'purchase_required_label'.tr()
                      : 'Available for Download',
                ),
                trailing: book.bookFile != null
                    ? Icon(
                        book.isPurchaseRequired ? Icons.lock : Icons.download,
                        color: book.isPurchaseRequired
                            ? Colors.amber
                            : Colors.green,
                      )
                    : const Icon(Icons.access_time, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel_btn'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pagesController.dispose();
    _yearController.dispose();
    _categoryController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrivateScaffold(
      title: 'sidebar_books_upload'.tr(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isFormVisible)
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _toggleForm(),
                    icon: const Icon(Icons.add),
                    label: Text('add_new_book_btn'.tr()),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'search_hint'.tr(),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Expanded(
              child: _isFormVisible
                  ? SingleChildScrollView(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _editingIndex != null
                                      ? 'action_edit'.tr()
                                      : 'add_new_book_btn'.tr(),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 20),
                                // Image Picker Logic
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        width: 100,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: _selectedImage != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: kIsWeb
                                                    ? Image.network(
                                                        _selectedImage!.path,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        File(
                                                          _selectedImage!.path,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.add_a_photo,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    'select_image_btn'.tr(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'book_cover_label'.tr(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          ElevatedButton(
                                            onPressed: _pickImage,
                                            child: Text(
                                              'select_image_btn'.tr(),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'upload_book_file_label'.tr(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: _pickBookFile,
                                                child: Text(
                                                  'select_file_btn'.tr(),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              if (_selectedBookFile != null)
                                                Expanded(
                                                  child: Text(
                                                    'file_selected'.tr(
                                                      namedArgs: {
                                                        'name':
                                                            _selectedBookFile!
                                                                .name,
                                                      },
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          CheckboxListTile(
                                            title: Text(
                                              'purchase_required_label'.tr(),
                                            ),
                                            value: _isPurchaseRequired,
                                            onChanged: (val) {
                                              setState(() {
                                                _isPurchaseRequired =
                                                    val ?? false;
                                              });
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'book_name_label'.tr(),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'validation_required'.tr(
                                          namedArgs: {
                                            'field': 'book_name_label'.tr(),
                                          },
                                        )
                                      : null,
                                ),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedAuthor,
                                  decoration: InputDecoration(
                                    labelText: 'book_author_label'.tr(),
                                  ),
                                  items: _authors
                                      .map(
                                        (author) => DropdownMenuItem(
                                          value: author,
                                          child: Text(author),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAuthor = value;
                                    });
                                  },
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'validation_required'.tr(
                                          namedArgs: {
                                            'field': 'book_author_label'.tr(),
                                          },
                                        )
                                      : null,
                                ),
                                TextFormField(
                                  controller: _pagesController,
                                  decoration: InputDecoration(
                                    labelText: 'book_pages_label'.tr(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'validation_required'.tr(
                                          namedArgs: {
                                            'field': 'book_pages_label'.tr(),
                                          },
                                        )
                                      : null,
                                ),
                                TextFormField(
                                  controller: _yearController,
                                  decoration: InputDecoration(
                                    labelText: 'book_year_label'.tr(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'validation_required'.tr(
                                          namedArgs: {
                                            'field': 'book_year_label'.tr(),
                                          },
                                        )
                                      : null,
                                ),
                                TextFormField(
                                  controller: _categoryController,
                                  decoration: InputDecoration(
                                    labelText: 'book_category_label'.tr(),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'validation_required'.tr(
                                          namedArgs: {
                                            'field': 'book_category_label'.tr(),
                                          },
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: _saveBook,
                                      child: Text('save_btn'.tr()),
                                    ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                      onPressed: () => _toggleForm(),
                                      child: Text('cancel_btn'.tr()),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : _filteredBooks.isEmpty
                  ? Center(child: Text('no_books_added'.tr()))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.grey[200],
                          ),
                          columnSpacing: 20,
                          columns: [
                            DataColumn(label: Text('book_cover_label'.tr())),
                            DataColumn(label: Text('book_name_label'.tr())),
                            DataColumn(label: Text('book_author_label'.tr())),
                            DataColumn(label: Text('book_pages_label'.tr())),
                            DataColumn(label: Text('book_year_label'.tr())),
                            DataColumn(label: Text('book_category_label'.tr())),
                            const DataColumn(label: Text('Download/Status')),
                            DataColumn(label: Text('table_actions'.tr())),
                          ],
                          rows: List.generate(_filteredBooks.length, (index) {
                            final book = _filteredBooks[index];
                            return DataRow(
                              cells: [
                                DataCell(
                                  book.image != null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: SizedBox(
                                              width: 30,
                                              height: 45,
                                              child: kIsWeb
                                                  ? Image.network(
                                                      book.image!.path,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(book.image!.path),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.book,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                ),
                                DataCell(Text(book.name)),
                                DataCell(Text(book.author)),
                                DataCell(Text(book.totalPages)),
                                DataCell(Text(book.publishedYear)),
                                DataCell(Text(book.category)),
                                DataCell(
                                  book.bookFile == null
                                      ? Text(
                                          'coming_soon'.tr(),
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : book.isPurchaseRequired
                                      ? Row(
                                          children: [
                                            const Icon(
                                              Icons.lock,
                                              size: 16,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Purchase Required',
                                              style: TextStyle(
                                                color: Colors.amber[800],
                                              ),
                                            ),
                                          ],
                                        )
                                      : ElevatedButton.icon(
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Downloading ${book.bookFile!.name}...',
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.download,
                                            size: 16,
                                          ),
                                          label: Text('download_btn'.tr()),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            textStyle: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.visibility,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => _viewBook(index),
                                        tooltip: 'action_view'.tr(),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                        onPressed: () =>
                                            _toggleForm(index: index),
                                        tooltip: 'action_edit'.tr(),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _deleteBook(index),
                                        tooltip: 'action_delete'.tr(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
