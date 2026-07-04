import 'dosage_scheme_item.dart';

class IntakePlanFull {
  final int planId;
  final String drugName;
  final DateTime startDate;
  final DateTime? endDate;
  final List<ScheduleItem> schedules;
  String colorHex;
  final List<DosageSchemeItem> dosageScheme;

  IntakePlanFull({
    required this.planId,
    required this.drugName,
    required this.startDate,
    required this.endDate,
    required this.schedules,
    required this.colorHex,
    required this.dosageScheme,
  });
}

class ScheduleItem {
  final String time;
  final String? days;
  final String? dose;
  final String? foodRule;

  ScheduleItem({
    required this.time,
    this.days,
    this.dose,
    this.foodRule,
  });
}