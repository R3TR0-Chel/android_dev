import "package:android_dev/screens/home_screen/services/dio_service.dart";
import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// DI: the one place Dio and DioService are created; tests can override them.
final dioProvider = Provider<Dio>((ref) => Dio());

final dioServiceProvider = Provider<DioService>(
  (ref) => DioService(ref.watch(dioProvider)),
);

// Loads the Search grid once and caches it.
final searchProvider = FutureProvider<List<dynamic>>((ref) async {
  final dioService = ref.watch(dioServiceProvider);
  final response = await dioService.get('https://dummyjson.com/products', 10);
  return response['products'] as List<dynamic>;
});
