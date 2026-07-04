import 'package:flutter/material.dart';

import '../../../themes/style.dart';

class DrugStepWidget extends StatelessWidget {
  final List<Map<String, dynamic>> drugs;
  final Map<String, dynamic>? selectedDrug;
  final Function(Map<String, dynamic>) onDrugSelected;
  final VoidCallback onAddNewDrug;

  const DrugStepWidget({
    super.key,
    required this.drugs,
    required this.selectedDrug,
    required this.onDrugSelected,
    required this.onAddNewDrug,
  });

  Color _parseColor(String hexCode) {
    final buffer = StringBuffer();
    if (hexCode.length == 7 && hexCode[0] == '#') {
      buffer.write(hexCode.substring(1));
    } else {
      buffer.write(hexCode);
    }
    return Color(int.parse('FF${buffer.toString()}', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите препарат',
          style: AppTextStyles.screenHeadline.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: drugs.length,
          itemBuilder: (context, index) {
            return _buildDrugCard(drugs[index]);
          },
        ),
      ],
    );
  }

  Widget _buildDrugCard(Map<String, dynamic> drug) {
    bool isSelected = selectedDrug?['ID'] == drug['ID'];

    String? unit = drug['Measurement'];
    if (unit == null || unit.isEmpty) {
      final drugType = drug['Drug_type_Name'];
      if (drugType != null) {
        switch (drugType.toString().toLowerCase()) {
          case 'таблетки': unit = 'таб.'; break;
          case 'капсулы': unit = 'капс.'; break;
          case 'сироп': unit = 'мл'; break;
          case 'раствор': unit = 'мл'; break;
          case 'капли': unit = 'кап.'; break;
        }
      }
    }

    return Card(
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: _parseColor(
            drug['Color']?.toString() ?? '#CCCCCC',
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (drug['Drug_type_Name'] != null)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade100 : AppColors.appGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  drug['Drug_type_Name'],
                  style: AppTextStyles.tagText.copyWith(
                    color: isSelected ? Colors.blue : null,
                  ),
                ),
              ),
            Text(
              drug['Name'] ?? '',
              style: AppTextStyles.cardHeadline.copyWith(
                color: isSelected ? Colors.blue : null,
              ),
            ),
          ],
        ),
        onTap: () => onDrugSelected(drug),
      ),
    );
  }
}