import "package:android_dev/screens/home_screen/data/mock_data.dart";
import "package:android_dev/screens/home_screen/services/dio_service.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// Dependency injection: these providers are the one place where services are
// created. Widgets and notifiers ask for them with ref.watch / ref.read
// instead of calling PostServices() or Dio() themselves, so a test can swap
// any of them for a fake with overrides.

final dioProvider = Provider<Dio>((ref) => Dio());

// DioService receives its Dio through the constructor (constructor injection).
final dioServiceProvider = Provider<DioService>(
  (ref) => DioService(ref.watch(dioProvider)),
);

// One PostServices for the whole app, filled with the mock data once.
final postServicesProvider = Provider<PostServices>((ref) {
  return PostServices()
    ..batchAddPosts(mockPosts)
    ..batchAddStories(mockStories);
});
