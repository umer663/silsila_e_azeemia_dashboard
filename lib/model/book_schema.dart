import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class Book {
  final String name;
  final String author;
  final String totalPages;
  final String publishedYear;
  final String category;
  final XFile? image;
  final PlatformFile? bookFile;
  final bool isPurchaseRequired;

  Book({
    required this.name,
    required this.author,
    required this.totalPages,
    required this.publishedYear,
    required this.category,
    this.image,
    this.bookFile,
    this.isPurchaseRequired = false,
  });

  Future<FormData> toFormData() async {
    MultipartFile? imageFile;
    if (image != null) {
      if (kIsWeb) {
        imageFile = MultipartFile.fromBytes(await image!.readAsBytes(), filename: image!.name);
      } else {
        imageFile = await MultipartFile.fromFile(image!.path, filename: image!.name);
      }
    }

    MultipartFile? bookFilePart;
    if (bookFile != null) {
      if (kIsWeb) {
        if (bookFile!.bytes != null) {
          bookFilePart = MultipartFile.fromBytes(bookFile!.bytes!, filename: bookFile!.name);
        }
      } else {
        if (bookFile!.path != null) {
          bookFilePart = await MultipartFile.fromFile(bookFile!.path!, filename: bookFile!.name);
        }
      }
    }

    return FormData.fromMap({
      'name': name,
      'author': author,
      'totalPages': totalPages,
      'publishedYear': publishedYear,
      'category': category,
      'isPurchaseRequired': isPurchaseRequired,
      if (imageFile != null) 'image': imageFile,
      if (bookFilePart != null) 'bookFile': bookFilePart,
    });
  }
}
