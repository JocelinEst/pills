import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;

  const EditButton({
    super.key,
    required this.onTap,
    this.width = 40,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 5),
        child: Image.asset(
          'assets/images/edit_btn.png',
          width: width,
          height: height,
        ),
      ),
    );
  }
}