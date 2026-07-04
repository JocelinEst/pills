class DosageSchemeItem {
  final int dayFromStart;
  final String time;
  final String? foodRule;
  final String? daysOfWeek;
  final String dose;

  DosageSchemeItem({
    required this.dayFromStart,
    required this.time,
    required this.dose,
    this.foodRule,
    this.daysOfWeek,
  });
}