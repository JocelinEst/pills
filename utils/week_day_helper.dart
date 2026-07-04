class WeekDayHelper {
  static const List<String> _days = [
    'Пн',
    'Вт',
    'Ср',
    'Чт',
    'Пт',
    'Сб',
    'Вс',
  ];

  static String getWeekDayName(int day) {
    return _days[day - 1];
  }
}