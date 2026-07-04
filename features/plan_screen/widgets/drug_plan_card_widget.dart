import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pills/models/view.dart';
import 'package:pills/themes/style.dart';
import 'package:pills/utils/view.dart';

class PlanDrugCard extends StatelessWidget {
  final DrugInfo drug;
  final VoidCallback onStatusToggle;
  final VoidCallback onEdit;

  const PlanDrugCard({
    super.key,
    required this.drug,
    required this.onStatusToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusButton(),
            const SizedBox(width: 17),
            Expanded(child: _buildDrugInfo()),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton() {
    return GestureDetector(
      onTap: onStatusToggle,
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: ColorHelper.hexToColor(drug.colorHex),
            width: 5.0,
          ),
        ),
        child: drug.isTaken
            ? const CustomPaint(
          size: Size(20, 20),
          painter: BoldCheckmarkPainter(),
        )
            : null,
      ),
    );
  }

  Widget _buildDrugInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3),
        Text(
          drug.formType ?? '—',
          style: GoogleFonts.montserratAlternates(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          drug.name,
          style: GoogleFonts.montserratAlternates(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        if (drug.prescription != null && drug.prescription!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 15),
            child: Text(
              drug.prescription!,
              style: GoogleFonts.montserratAlternates(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        Row(
          children: [
            if (drug.foodRule != null && drug.foodRule!.isNotEmpty)
              _buildFoodRuleChip(),
            _buildTimeText(),
            _buildDoseText(),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFoodRuleChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: FoodRuleHelper.getBackgroundColor(drug.foodRule!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        drug.foodRule!,
        style: AppTextStyles.contentText.copyWith(
          color: FoodRuleHelper.getTextColor(drug.foodRule!),
        )
      ),
    );
  }

  Widget _buildTimeText() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        drug.intakeTime,
        style: AppTextStyles.contentText
      ),
    );
  }

  Widget _buildDoseText() {
    final amountText = drug.amount != null
        ? drug.amount!.toString()
        : '';

    final unitText = drug.unit ?? '';

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        '$amountText $unitText',
        style: AppTextStyles.contentText,
      ),
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Image.asset(
          'assets/images/edit_btn.png',
          width: 30,
          height: 30,
        ),
      ),
    );
  }

}