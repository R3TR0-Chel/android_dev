import "package:flutter/material.dart";

class ImageGridItem extends StatelessWidget {
  final String imageUrl;
  const ImageGridItem({super.key, required this.imageUrl });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );

    
   
  }
}