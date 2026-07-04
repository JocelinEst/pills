import 'package:flutter/material.dart';
import 'package:pills/themes/style.dart';

class DrugHeader extends StatelessWidget {
  final VoidCallback onAddPressed;

  const DrugHeader({
    super.key,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Препараты',
              style: AppTextStyles.screenHeadline
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundUp,
              borderRadius: BorderRadius.circular(200),
            ),
            child: IconButton(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}