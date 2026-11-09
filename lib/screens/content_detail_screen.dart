import 'package:flutter/material.dart';

class ContentDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String title;
  const ContentDetailScreen({super.key, required this.imageUrl, required this.description, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                description,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}
