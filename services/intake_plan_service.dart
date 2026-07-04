import 'package:flutter/material.dart';
import 'package:pills/database/queries/intake_plan_queries.dart';
import 'package:sqflite/sqflite.dart';

import '../database/view.dart';
import '../models/dosage_scheme_item.dart';
import '../models/view.dart';
import '../utils/time_formatter.dart';

class IntakePlanService {
  final DatabaseHelper _db = DatabaseHelper.instance;


  Future<List<IntakePlanFull>> getIntakePlansFull() async {
    final result = await _db.rawQuery(IntakePlanQueries.getIntakePlansFull);
    final Map<int, IntakePlanFull> map = {};

    for (final row in result) {
      final id = row['plan_id'] as int;

      if (!map.containsKey(id)) {
        map[id] = IntakePlanFull(
          planId: id,
          drugName: row['drug_name'] ?? '',
          startDate: DateTime.parse(row['Start_date']),
          endDate: row['End_date'] != null
              ? DateTime.parse(row['End_date'])
              : null,
          schedules: [],
          colorHex: row['color_hex']?.toString() ?? '#FFFFFF',
          dosageScheme: [],
        );
      }
      if (row['Intake_time'] != null) {
        final dose = row['dose'] != null
            ? '${row['dose']} ${row['unit'] ?? ''}'.trim()
            : null;

        String? foodRule = row['food_rule']?.toString();
        map[id]!.schedules.add(
          ScheduleItem(
            time: TimeFormatter.formatTime(row['Intake_time']?.toString()),
            days: _formatDaysOfWeek(row['days']?.toString()),
            dose: dose,
            foodRule: foodRule,
          ),
        );
      }
    }
    for (final plan in map.values) {
      plan.dosageScheme.addAll(
        await _getDosageSchemeForPlan(plan.planId),
      );
    }
    return map.values.toList();
  }


  String? _formatDaysOfWeek(String? daysOfWeek) {
    if (daysOfWeek == null || daysOfWeek.isEmpty) return null;

    final daysMap = {
      '1': 'Пн', '2': 'Вт', '3': 'Ср', '4': 'Чт',
      '5': 'Пт', '6': 'Сб', '7': 'Вс'
    };

    final daysList = daysOfWeek.split(',');
    final formattedDays = daysList.map((d) => daysMap[d.trim()] ?? d).toList();

    return formattedDays.join(', ');
  }


  Future<List<DosageSchemeItem>> _getDosageSchemeForPlan(int planId) async {
    final result = await _db.rawQuery(
      IntakePlanQueries.getDosageSchemeForPlan(planId),
    );

    if (result.isEmpty) return [];

    final List<DosageSchemeItem> items = [];

    for (final row in result) {
      final amount = row['Amount'];
      final unit = row['unit'] ?? '';

      items.add(
        DosageSchemeItem(
          dayFromStart: row['Day_from_start'] as int,
          time: TimeFormatter.formatTime(
            row['Intake_time']?.toString(),
          ),
          foodRule: row['food_rule']?.toString(),
          daysOfWeek: _formatDaysOfWeek(
            row['days']?.toString(),
          ),
          dose: '$amount $unit',
        ),
      );
    }

    return items;
  }

  Future<void> createIntakePlan({
    required int drugId,
    required DateTime startDate,
    DateTime? endDate,
    required List<IntakeTimeWithDose> intakeTimes,
    String? schedulePattern,
    int? intervalDays,
    List<int>? selectedWeekDays,
    required String measurementUnit,
  }) async {
    await _db.transaction((txn) async {

      final planId = await txn.insert('Intake_plan', {
        'Drug_ID': drugId,
        'Start_date': _formatDate(startDate),
        'End_date': endDate != null ? _formatDate(endDate) : null,
        'Repeat_cycle': null,
        'Is_active': 1,
      });


      final List<int> timeScheduleIds = [];

      for (int i = 0; i < intakeTimes.length; i++) {
        final intake = intakeTimes[i];


        String? daysOfWeek;
        if (schedulePattern == 'weekly' && selectedWeekDays != null && selectedWeekDays.isNotEmpty) {
          daysOfWeek = selectedWeekDays.join(',');
        }

        final timeScheduleId = await txn.insert('Time_schedule', {
          'Intake_time': _formatTimeOfDay(intake.time),
          'Days_of_week': daysOfWeek,
          'Intake_plan_ID': planId,
        });

        timeScheduleIds.add(timeScheduleId);


        if (intake.doseAmount.isNotEmpty && double.tryParse(intake.doseAmount) != null) {
          final measurementUnitId = await _getMeasurementUnitId(txn, measurementUnit);
          await txn.insert('Dosage_rule', {
            'Day_from_start': 0,
            'Time_schedule_ID': timeScheduleId,
            'Measurement_unit_ID': measurementUnitId,
            'Amount': double.parse(intake.doseAmount),
          });
        }
      }
      await _generateScheduledIntakes(
          txn,
          planId,
          startDate,
          endDate,
          timeScheduleIds,
          schedulePattern,
          intervalDays,
          selectedWeekDays
      );
    });
  }


  String _formatTimeOfDay(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00";
  }


  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }


  Future<int> _getMeasurementUnitId(Transaction txn, String unitName) async {
    if (unitName.isEmpty) {
      unitName = 'тб.';
    }

    final result = await txn.query(
      'Measurement_units',
      where: 'Name = ?',
      whereArgs: [unitName],
    );

    if (result.isNotEmpty) {
      return result.first['ID'] as int;
    }


    return await txn.insert('Measurement_units', {'Name': unitName});
  }


  Future<void> _generateScheduledIntakes(
      Transaction txn,
      int planId,
      DateTime startDate,
      DateTime? endDate,
      List<int> timeScheduleIds,
      String? schedulePattern,
      int? intervalDays,
      List<int>? selectedWeekDays,
      ) async {
    final end = endDate ?? startDate.add(const Duration(days: 365));
    final List<DateTime> dates = [];


    DateTime currentDate = DateTime(startDate.year, startDate.month, startDate.day);

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      bool shouldAdd = true;

      if (schedulePattern == 'weekly' && selectedWeekDays != null && selectedWeekDays.isNotEmpty) {

        shouldAdd = selectedWeekDays.contains(currentDate.weekday);
      } else if (schedulePattern == 'days_interval' && intervalDays != null && intervalDays > 1) {
        final daysDiff = currentDate.difference(startDate).inDays;
        shouldAdd = daysDiff % intervalDays == 0;
      }

      if (shouldAdd) {
        dates.add(currentDate);
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }


    for (final date in dates) {
      final dateStr = _formatDate(date);


      for (final timeScheduleId in timeScheduleIds) {
        final timeStr = await _getTimeFromSchedule(txn, timeScheduleId);

        await txn.insert('Scheduled_intake', {
          'Intake_plan_ID': planId,
          'Time_schedule_ID': timeScheduleId,
          'Scheduled_date': '$dateStr $timeStr',
          'Status': 0,
        });
      }
    }
  }


  Future<String> _getTimeFromSchedule(Transaction txn, int timeScheduleId) async {
    final result = await txn.query(
      'Time_schedule',
      where: 'ID = ?',
      whereArgs: [timeScheduleId],
    );

    if (result.isNotEmpty) {
      return result.first['Intake_time'] as String;
    }
    return '00:00:00';
  }

}
