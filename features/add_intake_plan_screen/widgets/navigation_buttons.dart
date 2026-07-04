import 'package:flutter/material.dart';
import 'package:pills/themes/style.dart';

class NavigationButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool canProceed;

  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const NavigationButtons({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.canProceed,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Назад',
                  style: AppTextStyles.cardHeadline.copyWith(
                    color: AppColors.backgroundUp,
                  ),
                ),
              ),
            ),

          if (currentStep > 0)
            const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton(
              onPressed: canProceed ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canProceed ? AppColors.btnColor : Colors.grey.shade400,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: Text(
                currentStep == totalSteps - 1 ? 'Создать' : 'Далее',
                style: AppTextStyles.cardHeadline.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}