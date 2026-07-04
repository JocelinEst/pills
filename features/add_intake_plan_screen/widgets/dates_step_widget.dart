import 'package:flutter/material.dart';
import '../../../themes/style.dart';

class DatesStepWidget extends StatelessWidget {
  final String? intakeType;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime) onStartDateSelected;
  final Function(DateTime) onEndDateSelected;
  final String Function(DateTime) formatDate;

  const DatesStepWidget({
    super.key,
    required this.intakeType,
    required this.startDate,
    required this.endDate,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    if (intakeType == 'single') {
      return _buildSingleDateStep(context);
    }
    return _buildCourseDatesStep(context);
  }

  Widget _buildSingleDateStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите дату приема',
          style: AppTextStyles.screenHeadline.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 24),

        Center(
          child: GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) onStartDateSelected(date);
            },
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: startDate != null
                    ? Colors.blue.shade50
                    : Colors.grey.shade200,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Дата приема',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.cardHeadline.copyWith(
                        color: Colors.blue,
                        fontSize: 25
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      startDate != null
                          ? formatDate(startDate!)
                          : 'Не выбрано',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.cardHeadline.copyWith(
                        color: startDate != null ? Colors.blue : Colors.grey,
                        fontSize: 25
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDatesStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Выберите даты курса',
            style: AppTextStyles.screenHeadline.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 24),

        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date == null) return;
                  onStartDateSelected(date);
                },
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: startDate != null
                        ? Colors.blue.shade50
                        : Colors.grey.shade200,
                    border: Border.all(
                      color: startDate != null ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Дата начала',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardHeadline.copyWith(
                              color: Colors.blue,
                              fontSize: 25
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          startDate != null
                              ? formatDate(startDate!)
                              : 'Не выбрано',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardHeadline.copyWith(
                              color: startDate != null ? Colors.blue : Colors.grey,
                              fontSize: 25
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () async {
                  if (startDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Сначала выберите дату начала'),
                      ),
                    );
                    return;
                  }
                  final date = await showDatePicker(
                    context: context,
                    firstDate: startDate!.add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );

                  if (date == null) return;

                  if (date.isAtSameMomentAs(startDate!) ||
                      date.isBefore(startDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Дата окончания должна быть позже даты начала'),
                      ),
                    );
                    return;
                  }
                  onEndDateSelected(date);
                },
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: endDate != null
                        ? Colors.blue.shade50
                        : Colors.grey.shade200,
                    border: Border.all(
                      color: endDate != null ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Дата окончания',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardHeadline.copyWith(
                            fontSize: 25,
                            color: endDate != null
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          endDate != null
                              ? formatDate(endDate!)
                              : 'Не выбрано',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardHeadline.copyWith(
                            fontSize: 25,
                            color: endDate != null
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (startDate != null && endDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 45),
            child: Text(
              'Длительность курса ${endDate!.difference(startDate!).inDays + 1} дн.',
              style: AppTextStyles.cardHeadline.copyWith(
                      fontSize: 25,
                      color: AppColors.backgroundUp),
            ),
          ),
      ],
    );
  }
}