import 'package:flutter/material.dart';

class TimeFormatter {
  static String formatTime(String? time) {
    if (time == null || time.isEmpty) return '--:--';

    final parts = time.split(':');

    if (parts.length < 2) return time;

    final hh = parts[0].padLeft(2, '0');
    final mm = parts[1].padLeft(2, '0');

    return '$hh:$mm';
  }

  static String fromTimeOfDay(TimeOfDay time) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');

    return '$hh:$mm';
  }
}