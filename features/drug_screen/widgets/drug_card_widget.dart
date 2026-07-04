import 'package:flutter/material.dart';
import 'package:pills/themes/style.dart';
import '../../../utils/view.dart';
import '../../../models/view.dart';
import '../../button_widgets/view.dart';

class DrugCard extends StatelessWidget {
  final DrugInfo drug;
  final VoidCallback? onEdit;

  const DrugCard({
    super.key,
    required this.drug,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final color = ColorHelper.hexToColor(drug.colorHex);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: color,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (drug.formType != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.appGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      drug.formType!,
                      style: AppTextStyles.tagText,
                    ),
                  ),

                const SizedBox(height: 8),

                Text(
                  drug.name,
                  style: AppTextStyles.cardHeadline,
                ),

                const SizedBox(height: 16),

                if (drug.prescription != null)
                  Text(
                    drug.prescription!,
                    style: AppTextStyles.commonText,
                  ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.appGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'В упаковке: ${drug.quantityInPackage}',
                        style: AppTextStyles.commonText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Осталось: ${drug.currentQuantity}',
                        style: AppTextStyles.commonText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          EditButton(
            onTap: onEdit ?? () {},
          ),
        ],
      ),
    );
  }
}