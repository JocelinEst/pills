import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/btn_add.png',
        width: 48,
        height: 48,
        fit: BoxFit.contain,
      ),
    );
  }
}