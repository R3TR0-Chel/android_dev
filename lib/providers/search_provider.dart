import "package:android_dev/providers/service_providers.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// Loads the Search grid once and caches it. Replaces FutureBuilder +
// initState: the widget just watches this and gets loading / error / data.
final searchProvider = FutureProvider<List<dynamic>>((ref) async {
  final dioService = ref.watch(dioServiceProvider);
  final response = await dioService.get('https://dummyjson.com/products', 10);
  return response['products'] as List<dynamic>;
});
