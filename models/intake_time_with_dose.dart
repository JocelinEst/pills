import 'package:flutter/material.dart';

class IntakeTimeWithDose {
  TimeOfDay time;
  String doseAmount;
  String? foodCondition;

  IntakeTimeWithDose({
    required this.time,
    this.doseAmount = '',
    this.foodCondition,
  });
}