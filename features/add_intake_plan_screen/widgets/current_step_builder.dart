import 'package:flutter/material.dart';
import 'package:pills/features/add_intake_plan_screen/widgets/view.dart';
import '../../../models/intake_time_with_dose.dart';
import '../../../utils/view.dart';

class CurrentStepBuilder extends StatelessWidget {
  final int currentStep;
  final String? intakeType;
  final List<Map<String, dynamic>> drugs;
  final Map<String, dynamic>? selectedDrug;
  final List<IntakeTimeWithDose> intakeTimes;
  final String? schedulePattern;
  final int intervalDays;
  final List<int> selectedWeekDays;
  final Function(Map<String, dynamic>) onDrugSelected;
  final VoidCallback onAddNewDrug;
  final Function(String?) onTypeSelected;
  final Function(DateTime) onStartDateSelected;
  final Function(DateTime) onEndDateSelected;
  final Function(int) onRemoveIntakeTime;
  final Function(int, TimeOfDay) onUpdateTime;
  final Function(int, String) onUpdateDose;
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onAddIntakeTime;
  final List<String> foodConditions;
  final Function(int, String) onUpdateFoodCondition;
  final Function(String) onPatternSelected;
  final Function(int) onIntervalChanged;
  final Function(int) onWeekDayToggled;

  const CurrentStepBuilder({
    super.key,
    required this.onAddIntakeTime,
    required this.currentStep,
    required this.intakeType,
    required this.drugs,
    required this.selectedDrug,
    required this.intakeTimes,
    required this.schedulePattern,
    required this.intervalDays,
    required this.selectedWeekDays,
    required this.onDrugSelected,
    required this.onAddNewDrug,
    required this.onTypeSelected,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
    required this.onRemoveIntakeTime,
    required this.onUpdateTime,
    required this.onUpdateDose,
    required this.startDate,
    required this.endDate,
    required this.foodConditions,
    required this.onUpdateFoodCondition,
    required this.onPatternSelected,
    required this.onIntervalChanged,
    required this.onWeekDayToggled,

  });

  @override
  Widget build(BuildContext context) {
    if (drugs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    switch (currentStep) {
      case 0:
        return DrugStepWidget(
          drugs: drugs,
          selectedDrug: selectedDrug,
          onDrugSelected: onDrugSelected,
          onAddNewDrug: onAddNewDrug,
        );
      case 1:
        return TypeStepWidget(
          intakeType: intakeType,
          onTypeSelected: onTypeSelected,
        );
      case 2:
        return DatesStepWidget(
          key: ValueKey(startDate),
          intakeType: intakeType,
          startDate: startDate,
          endDate: endDate,
          onStartDateSelected: onStartDateSelected,
          onEndDateSelected: onEndDateSelected,
          formatDate: IntakePlanFormatter.formatDate,
        );
      case 3:
        return TimeStepWidget(
          intakeType: intakeType,
          measurementUnit: MeasurementUnitHelper.getUnit(selectedDrug),
          intakeTimes: intakeTimes,
          onAddIntakeTime: onAddIntakeTime,
          onRemoveIntakeTime: onRemoveIntakeTime,
          onUpdateTime: onUpdateTime,
          onUpdateDose: onUpdateDose,
          foodConditions: foodConditions,
          onUpdateFoodCondition: onUpdateFoodCondition,
          formatTime: IntakePlanFormatter.formatTime,
        );
      case 4:
        return ScheduleStepWidget(
          schedulePattern: schedulePattern,
          intervalDays: intervalDays,
          selectedWeekDays: selectedWeekDays,

          onPatternSelected: onPatternSelected,
          onIntervalChanged: onIntervalChanged,
          onWeekDayToggled: onWeekDayToggled,

          getWeekDayName: WeekDayHelper.getWeekDayName,
        );
      case 5:
        return ConfirmStepWidget(
          selectedDrug: selectedDrug,
          intakeType: intakeType,
          startDate: startDate,
          endDate: endDate,
          schedulePattern: schedulePattern,
          intervalDays: intervalDays,
          selectedWeekDays: selectedWeekDays,
          intakeTimes: intakeTimes,
          measurementUnit: MeasurementUnitHelper.getUnit(selectedDrug),

          formatDate: IntakePlanFormatter.formatDate,
          formatTime: IntakePlanFormatter.formatTime,
          getWeekDayName: WeekDayHelper.getWeekDayName,
        );
      default:
        return const SizedBox();
    }
  }
}