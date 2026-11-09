import "package:dio/dio.dart";

class DioService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> get(String url, int limit) async {
    try {
      final response = await _dio.get(url, queryParameters: {'limit': limit});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}