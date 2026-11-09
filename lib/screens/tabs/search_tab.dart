import "package:android_dev/screens/home_screen/services/dio_service.dart";
import "package:android_dev/widgets/image_grid_item.dart";
import "package:flutter/material.dart";

class SearchTab extends StatefulWidget {
  const new({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  DioService dioService = DioService();

  late Future <List<dynamic>> _futureData;

  Future<List<dynamic>> fetchData() async {
    final response = await dioService.get('https://dummyjson.com/products', 10);
    return response['products'] as List<dynamic>;
   
  }

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ImageGridItem(imageUrl: item['thumbnail']);
              },
            );
          }
        },
      ),
    );
  }
}
