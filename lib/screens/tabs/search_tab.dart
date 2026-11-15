import "package:android_dev/providers/search_provider.dart";
import "package:android_dev/widgets/image_grid_item.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// Same screen as before, but the data comes from searchProvider instead of
// a DioService + FutureBuilder created inside the widget.
class SearchTab extends ConsumerWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      // AsyncValue.when replaces the connectionState / hasError checks.
      body: products.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return ImageGridItem(
                imageUrl: item['thumbnail'],
                description: item['description'],
                title: item['title'],
              );
            },
          );
        },
      ),
    );
  }
}
