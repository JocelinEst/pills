import 'package:flutter/material.dart';

class IntakePlanFormatter {
  static String formatTime(TimeOfDay t) {
    return "${t.hour.toString().padLeft(2, '0')}:"
        "${t.minute.toString().padLeft(2, '0')}";
  }

  static String formatDate(DateTime d) {
    return "${d.day}.${d.month}.${d.year}";
  }
}