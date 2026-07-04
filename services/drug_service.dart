import 'package:sqflite/sqflite.dart';
import 'package:pills/database/database_helper.dart';
import 'package:pills/models/view.dart';
import 'package:pills/database/queries/view.dart';
import 'package:pills/utils/time_formatter.dart';
import '../models/food_condition_type.dart';

class DrugService {
  final DatabaseHelper _db = DatabaseHelper.instance;
  Future<List<DrugInfo>> getAllDrugsFull() async {
    final result = await _db.rawQuery(DrugQueries.getAllDrugsList);

    return result.map((row) {
      return DrugInfo(
        id: row['ID'] as int?,
        name: row['Name'] ?? '',
        colorHex: row['Color'] ?? '#CCCCCC',
        intakeTime: TimeFormatter.formatTime(row['Intake_time']?.toString()),
        isTaken: false,
        date: DateTime.now(),
        prescription: row['Prescription'],
        formType: row['Drug_type_Name'],
        amount: (row['amount'] as num?)?.toDouble(),
        unit: row['unit']?.toString(),
        quantityInPackage: row['Quantity_in_package'] ?? 0,
        currentQuantity: row['Current_quantity'] ?? 0,
        drugTypeId: row['Drug_type_ID'] as int?,
      );
    }).toList();
  }

  Future<List<FoodConditionType>> getFoodConditionTypes() async {
    final result = await _db.rawQuery(
      DrugQueries.getFoodConditionTypes,
    );
    return result
        .map(
          (e) => FoodConditionType.fromMap(e),
    )
        .toList();
  }

  Future<List<DrugInfo>> getAllDrugs() async {
    final result = await _db.rawQuery(ScheduledIntakeQueries.getAllDrugs);

    return result.map((row) {
      return DrugInfo(
        scheduledIntakeId: row['scheduled_id'] as int?,
        name: row['drug_name']?.toString() ?? '',
        colorHex: row['Color']?.toString() ?? '#CCCCCC',
        intakeTime: TimeFormatter.formatTime(row['Intake_time']?.toString()),
        isTaken: (row['Status'] as int?) == 1,
        prescription: row['Prescription']?.toString(),
        foodRule: row['food_rule']?.toString(),
        formType: row['form_type']?.toString(),
        amount: (row['amount'] as num?)?.toDouble(),
        unit: row['unit']?.toString(),
        date: DateTime.parse(row['Scheduled_date']),
        quantityInPackage: row['Quantity_in_package'] ?? 0,
        currentQuantity: row['Current_quantity'] ?? 0,
        drugTypeId: row['Drug_type_ID'] as int?,
      );
    }).toList();
  }

  Future<int> createDrug({
    required String name,
    required String colorHex,
    required int drugTypeId,
    required int quantityInPackage,
    String? prescription,
  }) async {
    final data = {
      'Name': name,
      'Prescription': prescription,
      'Quantity_in_package': quantityInPackage,
      'Current_quantity': quantityInPackage,
      'Color': colorHex,
      'Drug_type_ID': drugTypeId,
    };

    return await _db.insert('Drug', data);
  }

  Future<void> deleteDrug(int id) async {
    await _db.rawQuery(DrugQueries.deleteDrug(id));
  }

  Future<List<DrugType>> getDrugTypesTyped() async {
    final result = await _db.rawQuery(DrugQueries.getDrugTypes);
    return result.map((e) => DrugType.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getAllDrugsList() async {
    return await _db.rawQuery(DrugQueries.getAllDrugsList);
  }

  Future<List<DrugInfo>> getDrugsForDatePanel(DateTime date) async {
    final query = ScheduledIntakeQueries.getDrugsForDatePanel(date);
    final results = await _db.rawQuery(query);

    return results.map((row) {
      return DrugInfo(
        scheduledIntakeId: row['scheduled_id'] as int?,
        name: row['drug_name'] ?? '',
        colorHex: row['Color'] ?? '#CCCCCC',
        intakeTime: TimeFormatter.formatTime(row['Intake_time']?.toString()),
        isTaken: (row['Status'] as int?) == 1,
        prescription: row['Prescription'],
        foodRule: row['food_rule'],
        formType: row['form_type'],
        amount: (row['amount'] as num?)?.toDouble(),
        unit: row['unit']?.toString(),
        date: DateTime.parse(row['Scheduled_date']),
        quantityInPackage: row['Quantity_in_package'] ?? 0,
        currentQuantity: row['Current_quantity'] ?? 0,
        drugTypeId: row['Drug_type_ID'] as int?,
      );
    }).toList();
  }

  Future<void> updateDrugStatusById(int scheduledIntakeId, bool isTaken) async {
    await _db.rawQuery(ScheduledIntakeQueries.updateScheduledIntakeStatus(scheduledIntakeId, isTaken));
    if (isTaken) {
      final result = await _db.rawQuery(ScheduledIntakeQueries.getDrugIdAndDoseForScheduledIntake(scheduledIntakeId));
      if (result.isNotEmpty) {
        final drugId = result.first['drug_id'];
        final doseRaw = result.first['amount'];
        final dose = (doseRaw as num?)?.toInt();
        if (dose != null) {
          await decrementDrugQuantity(drugId, dose);
        }
      }
    }
  }

  Future<void> decrementDrugQuantity(int drugId, int amount) async {
    await _db.rawQuery(DrugQueries.decrementDrugQuantity(drugId, amount));
  }

  Future<void> incrementDrugQuantity(int drugId, int amount) async {
    await _db.rawQuery(DrugQueries.incrementDrugQuantity(drugId, amount));
  }

  Future<void> updateDrug({
    required int id,
    required String name,
    required String colorHex,
    required int drugTypeId,
    required int quantityInPackage,
    String? prescription,
  }) async {
    final data = {
      'Name': name,
      'Prescription': prescription,
      'Quantity_in_package': quantityInPackage,
      'Color': colorHex,
      'Drug_type_ID': drugTypeId,
    };

    await _db.update(
      'Drug',
      data,
      where: 'ID = ?',
      whereArgs: [id],
    );
  }

  Future<List<DrugInfo>> refreshDrugsForDate(DateTime date) async {
    final query = ScheduledIntakeQueries.getDrugsForDatePanel(date);
    final results = await _db.rawQuery(query);

    return results.map((row) {
      return DrugInfo(
        scheduledIntakeId: row['scheduled_id'] as int?,
        name: row['drug_name'] ?? '',
        colorHex: row['Color'] ?? '#CCCCCC',
        intakeTime: TimeFormatter.formatTime(row['Intake_time']?.toString()),
        isTaken: (row['Status'] as int?) == 1,
        prescription: row['Prescription'],
        foodRule: row['food_rule'],
        formType: row['form_type'],
        amount: (row['amount'] as num?)?.toDouble(),
        unit: row['unit']?.toString(),
        date: DateTime.parse(row['Scheduled_date']),
        quantityInPackage: row['Quantity_in_package'] ?? 0,
        currentQuantity: row['Current_quantity'] ?? 0,
        drugTypeId: row['Drug_type_ID'] as int?,
      );
    }).toList();
  }

  Future<void> updateDrugPlan({
    required int scheduledIntakeId,
    required String intakeTime,
    required double dose,
    String? foodRule,
  }) async {
    final db = await _db.database;
    final scheduledResult = await db.query(
      'Scheduled_intake',
      columns: ['Time_schedule_ID', 'Intake_plan_ID'],
      where: 'ID = ?',
      whereArgs: [scheduledIntakeId],
    );
    if (scheduledResult.isEmpty) {
      throw Exception('Scheduled intake not found');
    }
    final timeScheduleId = scheduledResult.first['Time_schedule_ID'] as int;
    final intakePlanId = scheduledResult.first['Intake_plan_ID'] as int;
    await db.transaction((txn) async {
      await txn.update(
        'Time_schedule',
        {'Intake_time': intakeTime},
        where: 'ID = ?',
        whereArgs: [timeScheduleId],
      );
      await txn.update(
        'Dosage_rule',
        {'Amount': dose},
        where: 'Time_schedule_ID = ? AND Day_from_start = ?',
        whereArgs: [timeScheduleId, 0],
      );
      if (foodRule != null && foodRule.isNotEmpty) {
        final foodRuleResult = await txn.query(
          'Food_condition_types',
          columns: ['ID'],
          where: 'Name = ?',
          whereArgs: [foodRule],
        );
        if (foodRuleResult.isNotEmpty) {
          final foodRuleId = foodRuleResult.first['ID'] as int;

          final existingRecord = await txn.query(
            'Food_intake_condition',
            where: 'Time_schedule_ID = ?',
            whereArgs: [timeScheduleId],
          );

          if (existingRecord.isNotEmpty) {
            await txn.update(
              'Food_intake_condition',
              {'Food_condition_type_ID': foodRuleId},
              where: 'Time_schedule_ID = ?',
              whereArgs: [timeScheduleId],
            );
          } else {
            await txn.insert(
              'Food_intake_condition',
              {
                'Time_schedule_ID': timeScheduleId,
                'Food_condition_type_ID': foodRuleId,
              },
            );
          }
        }
      }
    });
  }

  Future<bool> hasIntakeHistory(int drugId) async {
    try {
      final result = await _db.rawQuery(DrugQueries.checkIntakeHistory(drugId));
      final count = Sqflite.firstIntValue(result);
      return (count ?? 0) > 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteScheduledIntake(int scheduledIntakeId) async {
    final db = await _db.database;
    final scheduledResult = await db.query(
      'Scheduled_intake',
      columns: ['Time_schedule_ID', 'Intake_plan_ID'],
      where: 'ID = ?',
      whereArgs: [scheduledIntakeId],
    );
    if (scheduledResult.isEmpty) {
      throw Exception('Scheduled intake not found');
    }
    final timeScheduleId = scheduledResult.first['Time_schedule_ID'] as int;
    final intakePlanId = scheduledResult.first['Intake_plan_ID'] as int;
    await db.transaction((txn) async {
      await txn.delete(
        'Scheduled_intake',
        where: 'ID = ?',
        whereArgs: [scheduledIntakeId],
      );
      await txn.delete(
        'Time_schedule',
        where: 'ID = ?',
        whereArgs: [timeScheduleId],
      );
      final remainingCount = await txn.query(
        'Scheduled_intake',
        columns: ['ID'],
        where: 'Intake_plan_ID = ?',
        whereArgs: [intakePlanId],
      );
      if (remainingCount.isEmpty) {
        await txn.update(
          'Intake_plan',
          {'Is_active': 0},
          where: 'ID = ?',
          whereArgs: [intakePlanId],
        );
      }
    });
  }
}