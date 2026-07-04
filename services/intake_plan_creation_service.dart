import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/intake_time_with_dose.dart';
import '../utils/view.dart';
import 'intake_plan_service.dart';

class IntakePlanCreationService {
  final IntakePlanService intakePlanService;

  IntakePlanCreationService(
      this.intakePlanService,
      );

  Future<List<Map<String, dynamic>>> getAllFoodConditions() async {
    final Database db = await DatabaseHelper.instance.database;

    return await db.query(
      'Food_condition_types',
      orderBy: 'Name ASC',
    );
  }
  Future<void> createPlan({
    required Map<String, dynamic> selectedDrug,
    required String? intakeType,
    required DateTime startDate,
    required DateTime? endDate,
    required List<IntakeTimeWithDose> intakeTimes,
    required String? schedulePattern,
    required int intervalDays,
    required List<int> selectedWeekDays,
  }) async {
    final measurementUnit =
    MeasurementUnitHelper.getUnit(
      selectedDrug,
    );
    await intakePlanService.createIntakePlan(
      drugId: selectedDrug['ID'] as int,
      startDate: startDate,
      endDate: intakeType == 'single'
          ? startDate
          : endDate,
      intakeTimes: intakeTimes,
      schedulePattern: intakeType == 'single'
          ? null
          : schedulePattern,
      intervalDays: intakeType == 'single'
          ? null
          : intervalDays,
      selectedWeekDays: intakeType == 'single'
          ? null
          : selectedWeekDays,
      measurementUnit: measurementUnit,
    );
  }
}