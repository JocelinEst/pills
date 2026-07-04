// lib/features/main_screen/widgets/calendar_grid_widget.dart

import 'package:flutter/material.dart';
import 'package:pills/features/one_day/one_day.dart';
import 'package:pills/models/view.dart';

class CalendarGrid extends StatelessWidget {
  final int daysInMonth;
  final List<List<DrugInfo>> allDrugs;
  final double cellSize;
  final bool Function(int) isToday;
  final bool Function(int) isPast;
  final Function(int) onDaySelected;

  const CalendarGrid({
    super.key,
    required this.daysInMonth,
    required this.allDrugs,
    required this.cellSize,
    required this.isToday,
    required this.isPast,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    const cols = 5;
    const rows = 7;

    return ClipRect(
      child: Column(
        children: List.generate(rows, (row) {
          return Expanded(
            child: Row(
              children: List.generate(cols, (col) {
                final day = row * cols + col + 1;

                if (day > daysInMonth) {
                  return const Expanded(child: SizedBox());
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      width: cellSize,
                      height: cellSize,
                      child: OneDay(
                        dayNumber: '$day',
                        isToday: isToday(day),
                        isPast: isPast(day),
                        drugs: allDrugs[day - 1],
                        onDaySelected: () => onDaySelected(day),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}