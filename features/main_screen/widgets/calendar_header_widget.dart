import 'package:flutter/material.dart';
import '../../../../themes/style.dart';

class CalendarHeader extends StatelessWidget {
  final String monthName;
  final int year;

  const CalendarHeader({
    super.key,
    required this.monthName,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          '$monthName $year',
          style: AppTextStyles.headline,
        ),
      ),
    );
  }
}