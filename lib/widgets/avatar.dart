import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const Avatar({
    super.key,
    required this.imageUrl,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.person,
            color: Colors.grey[600],
            size: radius,
          ),
        ),
      ),
    );
  }
}
