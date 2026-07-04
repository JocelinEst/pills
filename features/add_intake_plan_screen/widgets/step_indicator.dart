import 'package:flutter/material.dart';

import '../../../themes/style.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final String? intakeType;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.intakeType,
  });
  @override
  Widget build(BuildContext context) {
    final totalSteps = intakeType == 'single' ? 4 : 6;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;
          return Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 20,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.green
                                : isActive
                                ? AppColors.backgroundUp
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: isActive
                                ? Border.all(
                              color: Colors.white,
                              width: 4,
                            )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

}