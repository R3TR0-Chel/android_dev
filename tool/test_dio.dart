
import 'package:dio/dio.dart';
import 'package:android_dev/screens/home_screen/services/dio_service.dart';

Future<void> main() async {
  final dio = Dio();
  final dioService = DioService(dio);

  try {
    final data = await dioService.get(
      'https://jsonplaceholder.typicode.com/posts',
    );

    print('API работает!');
    print('Количество постов: ${data.length}');
    print('Первый пост: ${data[0]['title']}');
  } catch (e) {
    print('Ошибка: $e');
  }
}
