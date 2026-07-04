import 'package:flutter/material.dart';
import 'package:pills/models/view.dart';
import 'package:pills/services/view.dart';
import 'calendar_grid_widget.dart';
import 'calendar_header_widget.dart';

class CalendarWidget extends StatefulWidget {
  final int daysInMonth;
  final String nameOfMonth;
  final int year;
  final DateTime displayedDate;
  final VoidCallback? onRefresh;
  final Function(DateTime)? onDateSelected;

  const CalendarWidget({
    super.key,
    required this.daysInMonth,
    required this.nameOfMonth,
    required this.year,
    required this.displayedDate,
    this.onRefresh,
    this.onDateSelected,
  });

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  final DrugService _service = DrugService();
  int _refreshKey = 0;

  DateTime _date(int day) =>
      DateTime(widget.year, widget.displayedDate.month, day);

  bool _isToday(int day) {
    final now = DateTime.now();
    final d = _date(day);
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  bool _isPast(int day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _date(day).isBefore(today);
  }

  Future<List<DrugInfo>> _getDrugsForDay(int day) {
    return _service.getDrugsForDatePanel(_date(day));
  }

  void refreshCalendar() {
    setState(() => _refreshKey++);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const cols = 5;
        final cellSize = (constraints.maxWidth / cols).clamp(40.0, 80.0);
        const rightPadding = 16.0;

        return Column(
          children: [
            CalendarHeader(
              monthName: widget.nameOfMonth,
              year: widget.year,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: rightPadding),
                child: FutureBuilder<List<List<DrugInfo>>>(
                  key: ValueKey(_refreshKey),
                  future: Future.wait(
                    List.generate(
                      widget.daysInMonth,
                          (index) => _getDrugsForDay(index + 1),
                    ),
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return CalendarGrid(
                      daysInMonth: widget.daysInMonth,
                      allDrugs: snapshot.data!,
                      cellSize: cellSize,
                      isToday: _isToday,
                      isPast: _isPast,
                      onDaySelected: (day) => widget.onDateSelected?.call(_date(day)),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}