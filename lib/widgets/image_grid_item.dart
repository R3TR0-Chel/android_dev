import "package:android_dev/screens/content_detail_screen.dart";
import "package:flutter/material.dart";

class ImageGridItem extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String title;
  const ImageGridItem({super.key, required this.imageUrl, required this.description, required this.title });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentDetailScreen(imageUrl: imageUrl, description: description, title: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    
   
  }
}