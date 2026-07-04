import 'package:flutter/material.dart';
import 'package:pills/models/view.dart';
import '../../../themes/style.dart';
import '../../../utils/food_rule_helper.dart';

class TimeStepWidget extends StatelessWidget {
  final String? intakeType;
  final String? measurementUnit;
  final List<IntakeTimeWithDose> intakeTimes;
  final Function() onAddIntakeTime;
  final Function(int) onRemoveIntakeTime;
  final Function(int, TimeOfDay) onUpdateTime;
  final Function(int, String) onUpdateDose;
  final String Function(TimeOfDay) formatTime;
  final List<String> foodConditions;
  final Function(int, String) onUpdateFoodCondition;

  const TimeStepWidget({
    super.key,
    required this.intakeType,
    required this.measurementUnit,
    required this.intakeTimes,
    required this.onAddIntakeTime,
    required this.onRemoveIntakeTime,
    required this.onUpdateTime,
    required this.onUpdateDose,
    required this.formatTime,
    required this.foodConditions,
    required this.onUpdateFoodCondition,
  });

  @override
  Widget build(BuildContext context) {
    bool allDosesFilled = intakeTimes.isNotEmpty && intakeTimes.every((intake) =>
    intake.doseAmount.isNotEmpty && double.tryParse(intake.doseAmount) != null
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intakeType == 'single'
              ? 'Уточните детали приема'
              : 'Уточните детали курса',
          style: AppTextStyles.screenHeadline.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 18),
        Text(
          intakeType == 'course' && intakeTimes.length >= 4
              ? 'Максимум 4 приема в день'
              : 'Необходимо указать количество приемов в день, время, дозировку и связь с приемом пищи.',
          style: AppTextStyles.contentText.copyWith(color: Colors.white, fontSize: 18),
        ),

        if (intakeTimes.isNotEmpty && !allDosesFilled)
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),

              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange.shade700,
                    size: 35,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Заполните дозировку для всех приемов',
                      style: AppTextStyles.cardHeadline.copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),

        ...intakeTimes.asMap().entries.map((entry) {
          int idx = entry.key;
          IntakeTimeWithDose intake = entry.value;
          return _buildIntakeCard(intake, idx, measurementUnit, context);
        }),

        if (intakeTimes.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(20),

            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.access_time, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text('Нет добавленных приемов', style: AppTextStyles.cardHeadline.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),

                ],
              ),
            ),
          ),

        if (intakeType != 'single' || intakeTimes.length < 4)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: OutlinedButton.icon(
              onPressed: onAddIntakeTime,
              label: Text(
                'Добавить прием',
                style: AppTextStyles.cardHeadline.copyWith(
                  color: AppColors.backgroundUp,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIntakeCard(
      IntakeTimeWithDose intake,
      int index,
      String? unit,
      BuildContext context,
      ) {
    final doseController = TextEditingController(
      text: intake.doseAmount,
    );

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.cardHeadline.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.w900,
                      fontSize: 25
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    formatTime(intake.time),
                    style: AppTextStyles.menuHeadline.copyWith(color: Colors.black, fontSize: 25),
                  ),
                ),

                IconButton(
                  onPressed: () async {
                    final newTime = await showTimePicker(
                      context: context,
                      initialTime: intake.time,
                    );
                    if (newTime != null) {
                      onUpdateTime(index, newTime);
                    }
                  },
                  icon: Image.asset(
                    'assets/images/edit_btn.png',
                    width: 35,
                    height: 35,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 35,),
                  onPressed: () => onRemoveIntakeTime(index),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: doseController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Укажите дозировку',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          onUpdateDose(index, value);
                        },
                      ),
                    ),

                    if (unit != null) ...[
                      const SizedBox(width: 12),

                      Text(
                        unit,
                        style: AppTextStyles.cardHeadline,
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: intake.foodCondition,
                  itemHeight: 60,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),

                  hint: const Text('Правило приема пищи'),

                  items: foodConditions.map((condition) {
                    return DropdownMenuItem<String>(
                      value: condition,

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: FoodRuleHelper.getBackgroundColor(
                            condition,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          condition,
                          style: TextStyle(
                            color: FoodRuleHelper.getTextColor(
                              condition,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  onChanged: (value) {
                    if (value != null) {
                      onUpdateFoodCondition(index, value);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}