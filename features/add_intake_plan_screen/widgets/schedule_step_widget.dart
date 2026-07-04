import 'package:flutter/material.dart';
import '../../../themes/style.dart';

class ScheduleStepWidget extends StatelessWidget {
  final String? schedulePattern;
  final int intervalDays;
  final List<int> selectedWeekDays;
  final Function(String) onPatternSelected;
  final Function(int) onIntervalChanged;
  final Function(int) onWeekDayToggled;
  final String Function(int) getWeekDayName;

  const ScheduleStepWidget({
    super.key,
    required this.schedulePattern,
    required this.intervalDays,
    required this.selectedWeekDays,
    required this.onPatternSelected,
    required this.onIntervalChanged,
    required this.onWeekDayToggled,
    required this.getWeekDayName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите частоту курса',
          style: AppTextStyles.screenHeadline.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 24),
        _buildScheduleCard(
          title: 'Каждый день',
          description: 'Принимать ежедневно',
          value: 'daily',
          onTap: () => onPatternSelected('daily'),
        ),
        const SizedBox(height: 12),
        _buildScheduleCard(
          title: 'С интервалом',
          description: 'Например: каждые два дня',
          value: 'days_interval',
          onTap: () => onPatternSelected('days_interval'),
          child: schedulePattern == 'days_interval'
              ? Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: intervalDays.toString(),
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Интервал',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: AppColors.backgroundUp,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: AppColors.backgroundUp,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: AppColors.backgroundUp,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);

                      if (parsed != null && parsed > 0) {
                        onIntervalChanged(parsed);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Text(
                  'дн.',
                  style: AppTextStyles.cardHeadline.copyWith(color:AppColors.backgroundUp),
                ),
              ],
            ),
          )
              : null,
        ),
        const SizedBox(height: 12),
        _buildScheduleCard(
          title: 'По дням недели',
          description: 'Выбрать конкретные дни',
          value: 'weekly',
          onTap: () => onPatternSelected('weekly'),
          child: schedulePattern == 'weekly'
              ? Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: List.generate(7, (index) {
                int day = index + 1;
                bool isSelected = selectedWeekDays.contains(day);
                return GestureDetector(
                  onTap: () => onWeekDayToggled(day),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.shade100
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      getWeekDayName(day),
                      style: AppTextStyles.contentText.copyWith(
                        color: isSelected ? Colors.blue.shade900 : Colors.black,
                        fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          )
              : null,
        ),
      ],
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required String description,
    required VoidCallback onTap,
    required String value,
    Widget? child,
  }) {
    final bool isSelected = schedulePattern == value;

    return Card(
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      child: Column(
        children: [
          ListTile(
            isThreeLine: true,

            title: Text(
              title,
              style: AppTextStyles.cardHeadline.copyWith(
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 7, bottom: 10),
              child: Text(
                description,
                style: AppTextStyles.contentText.copyWith(
                  color: isSelected ? Colors.blue : Colors.black87,
                ),
              ),
            ),

            onTap: onTap,
          ),

          if (child != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}