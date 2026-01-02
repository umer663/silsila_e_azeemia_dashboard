import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silsila_e_azeemia_dashboard/model/book_schema.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  }

  Future<void> addBook(Book book) async {
    try {
      final formData = await book.toFormData();
      await _dio.post('/books', data: formData);
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }
}
