
import 'package:dio/dio.dart';

class DioService {
  final Dio _dio;

  DioService(this._dio);

  Future<dynamic> get(String url, {int limit = 10}) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: {'limit': limit},
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load data: ${e.message}');
    }
  }
}
