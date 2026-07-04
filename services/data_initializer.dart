import 'package:sqflite/sqflite.dart';
import '../database/queries/view.dart';

class DataInitializer {
  Future<void> insertReferenceData(Database db) async {
    for (final unit in DatabaseQueriesTestData.measurementUnits) {
      await db.insert('Measurement_units', unit);
    }
    for (final type in DatabaseQueriesTestData.foodConditionTypes) {
      await db.insert('Food_condition_types', type);
    }
    for (final type in DatabaseQueriesTestData.drugTypes) {
      await db.insert('Drug_types', type);
    }
  }
  Future<void> insertTestData(Database db) async {
    for (final drug in DatabaseQueriesTestData.testDrugs) {
      await db.insert('Drug', drug);
    }
    for (final plan in DatabaseQueriesTestData.getTestIntakePlans()) {
      await db.insert('Intake_plan', plan);
    }
    for (final schedule in DatabaseQueriesTestData.testTimeSchedules) {
      await db.insert('Time_schedule', schedule);
    }
    for (final rule in DatabaseQueriesTestData.testDosageRules) {
      await db.insert('Dosage_rule', rule);
    }
    for (final condition in DatabaseQueriesTestData.testFoodIntakeConditions) {
      await db.insert('Food_intake_condition', condition);
    }
    for (final scheduled in DatabaseQueriesTestData.generateTestScheduledIntakes()) {
      await db.insert('Scheduled_intake', scheduled);
    }
    for (final actual in DatabaseQueriesTestData.getTestActualIntakes()) {
      await db.insert('Actual_intake', actual);
    }

    await recalculateCurrentQuantities(db);
  }
  Future<void> recalculateCurrentQuantities(Database db) async {
    try {
      final drugs = await db.query('Drug');

      for (var drug in drugs) {
        final drugId = drug['ID'] as int;
        final quantityInPackage = drug['Quantity_in_package'] as int;

        final result = await db.rawQuery(DosageRuleQueries.getTotalUsedForDrug(drugId));

        final totalUsed = result.first['total_used'] as int? ?? 0;
        final newQuantity = (quantityInPackage - totalUsed).clamp(0, quantityInPackage);

        await db.execute(DrugQueries.updateDrugCurrentQuantity(drugId, newQuantity));
      }

    } catch (e) {
      await db.execute(DrugQueries.resetAllCurrentQuantities);
    }
  }

}