import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? backgroundColor; // Ditambahkan parameter backgroundColor

  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    this.backgroundColor, // Ditambahkan ke constructor
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 80),
        backgroundColor: backgroundColor, // Diterapkan ke style
      ),
      child: Text(
        title,
      ),
    );
  }
}