import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:silsila_e_azeemia_dashboard/model/book_schema.dart';

class BookService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addBook(Book book) async {
    try {
      String? imageUrl;
      String? bookUrl;

      // 1. Upload Image (if exists)
      if (book.image != null) {
        final imageBytes = await book.image!.readAsBytes();
        final imagePath =
            'covers/${DateTime.now().millisecondsSinceEpoch}_${book.image!.name}';

        await _supabase.storage
            .from('book-covers')
            .uploadBinary(
              imagePath,
              imageBytes,
              fileOptions: const FileOptions(upsert: true),
            );

        imageUrl = _supabase.storage
            .from('book-covers')
            .getPublicUrl(imagePath);
      }

      // 2. Upload Book File (if exists)
      if (book.bookFile != null) {
        final bookPath =
            'files/${DateTime.now().millisecondsSinceEpoch}_${book.bookFile!.name}';

        if (kIsWeb) {
          if (book.bookFile!.bytes != null) {
            await _supabase.storage
                .from('book-files')
                .uploadBinary(
                  bookPath,
                  book.bookFile!.bytes!,
                  fileOptions: const FileOptions(upsert: true),
                );
          }
        } else {
          if (book.bookFile!.path != null) {
            await _supabase.storage
                .from('book-files')
                .upload(
                  bookPath,
                  File(book.bookFile!.path!),
                  fileOptions: const FileOptions(upsert: true),
                );
          }
        }

        bookUrl = _supabase.storage.from('book-files').getPublicUrl(bookPath);
      }

      // 3. Insert into Database
      await _supabase.from('books').insert({
        'name': book.name,
        'author': book.author,
        'total_pages': book.totalPages,
        'published_year': book.publishedYear,
        'category': book.category,
        'image_url': imageUrl,
        'book_url': bookUrl,
        'is_purchase_required': book.isPurchaseRequired,
      });
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }
}
