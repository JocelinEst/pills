import 'package:flutter/material.dart';

import '../../../themes/style.dart';

class TypeStepWidget extends StatelessWidget {
  final String? intakeType;
  final Function(String) onTypeSelected;

  const TypeStepWidget({
    super.key,
    required this.intakeType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Какой тип приема?',
          style: AppTextStyles.screenHeadline.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 24),
        _buildTypeCard(
          title: 'Разовый прием',
          description: 'Принять один раз в определенное время',
          isSelected: intakeType == 'single',
          onTap: () => onTypeSelected('single'),
        ),
        const SizedBox(height: 16),
        _buildTypeCard(
          title: 'Курс лечения',
          description: 'Регулярный прием по расписанию на определенный период',
          isSelected: intakeType == 'course',
          onTap: () => onTypeSelected('course'),
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      color: isSelected ? Colors.blue.shade50 : null,
      child: ListTile(
        isThreeLine: true,
        title: Text(
          title,
          style: AppTextStyles.cardHeadline.copyWith(
            color: isSelected ? Colors.blue : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 10),
          child: Text(
            description,
            style: AppTextStyles.contentText.copyWith(
              color: isSelected ? Colors.blue : null,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}