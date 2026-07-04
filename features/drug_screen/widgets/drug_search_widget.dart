import 'package:flutter/material.dart';
import 'package:pills/themes/style.dart';

class DrugSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DrugSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Введите название...',
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.black,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: AppColors.borderColor,
              width: 1.5,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: AppColors.borderColor,
              width: 3,
            ),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: AppColors.borderColor,
              width: 1.5,
            ),
          ),
        ),
        style: AppTextStyles.contentText,
      ),
    );
  }
}