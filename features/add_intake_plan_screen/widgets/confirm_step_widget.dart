import 'package:flutter/material.dart';
import 'package:pills/models/view.dart';

import '../../../themes/style.dart';

class ConfirmStepWidget extends StatelessWidget {
  final Map<String, dynamic>? selectedDrug;
  final String? intakeType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? schedulePattern;
  final int intervalDays;
  final List<int> selectedWeekDays;
  final List<IntakeTimeWithDose> intakeTimes;
  final String? measurementUnit;
  final String Function(DateTime) formatDate;
  final String Function(TimeOfDay) formatTime;
  final String Function(int) getWeekDayName;

  const ConfirmStepWidget({
    super.key,
    required this.selectedDrug,
    required this.intakeType,
    required this.startDate,
    required this.endDate,
    required this.schedulePattern,
    required this.intervalDays,
    required this.selectedWeekDays,
    required this.intakeTimes,
    required this.measurementUnit,
    required this.formatDate,
    required this.formatTime,
    required this.getWeekDayName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Проверьте данные',
            style: AppTextStyles.screenHeadline,
          ),

          const SizedBox(height: 28),

          _buildSection(
            title: 'Препарат',
            value: selectedDrug?['Name'] ?? '—',
          ),

          const SizedBox(height: 20),

          _buildSection(
            title: 'Тип приема',
            value: intakeType == 'single'
                ? 'Разовый'
                : 'Курс',
          ),

          if (intakeType == 'course') ...[
            const SizedBox(height: 20),

            _buildSection(
              title: 'Период',
              value:
              'С ${startDate != null ? formatDate(startDate!) : '—'}  по '
                  '${endDate != null ? formatDate(endDate!) : 'На постоянной основе'}',
            ),

            const SizedBox(height: 20),

            _buildSection(
              title: 'Расписание',
              value: _getScheduleDescription(),
            ),
          ],

          const SizedBox(height: 28),

           Text(
            'Режим приема',
            style: AppTextStyles.menuItem.copyWith(fontSize: 20, fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 16),

          ...intakeTimes.map((intake) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.appGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      formatTime(intake.time),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.menuItem.copyWith(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intake.doseAmount.isNotEmpty
                              ? '${intake.doseAmount} ${measurementUnit ?? ''}'
                              : 'Дозировка не указана',
                          style: AppTextStyles.menuItem.copyWith(fontSize: 18)
                        ),

                        if (intake.foodCondition != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              intake.foodCondition!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
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
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            color: AppColors.appGrey,
            borderRadius: BorderRadius.circular(20),
          ),

            child: Text(
              title,
              style: AppTextStyles.menuItem.copyWith(
                fontSize: 15,
              ),
            ),

        ),

        const SizedBox(height: 4),

        Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, bottom: 10),
          child: Text(
            value,
            style: AppTextStyles.menuItem,
          ),
        ),
      ],
    );
  }



  String _getScheduleDescription() {
    switch (schedulePattern) {
      case 'daily': return 'Каждый день';
      case 'days_interval': return 'Каждые $intervalDays дня';
      case 'weekly': return selectedWeekDays.map((d) => getWeekDayName(d)).join(', ');
      default: return '—';
    }
  }
}