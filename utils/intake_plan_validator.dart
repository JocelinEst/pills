import 'package:pills/models/view.dart';

class IntakePlanValidator {
  static bool canProceed({
    required int currentStep,
    required Map<String, dynamic>? selectedDrug,
    required String? intakeType,
    required DateTime? startDate,
    required List<IntakeTimeWithDose> intakeTimes,
    required String? schedulePattern,
    required int intervalDays,
    required List<int> selectedWeekDays,
  }) {
    switch (currentStep) {

      case 0:
        return selectedDrug != null;

      case 1:
        return intakeType != null;

      case 2:
        return startDate != null;

      case 3:
        if (intakeTimes.isEmpty) {
          return false;
        }

        return intakeTimes.every(
              (intake) =>
          intake.doseAmount.isNotEmpty &&
              double.tryParse(intake.doseAmount) != null &&
              double.parse(intake.doseAmount) > 0,
        );

      case 4:
        if (intakeType == 'single') {
          return true;
        }

        if (schedulePattern == 'daily') {
          return true;
        }

        if (schedulePattern == 'days_interval') {
          return intervalDays > 0;
        }

        if (schedulePattern == 'weekly') {
          return selectedWeekDays.isNotEmpty;
        }

        return false;

      default:
        return true;
    }
  }
}