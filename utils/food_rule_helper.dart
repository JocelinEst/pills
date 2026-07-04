import 'package:flutter/material.dart';

class FoodRuleHelper {
  static Color getBackgroundColor(String foodRule) {
    final rule = foodRule.toLowerCase();
    if (rule.contains('до еды') || rule.contains('натощак')) {
      return const Color.fromRGBO(255, 226, 206, 1);
    } else if (rule.contains('после еды')) {
      return const Color.fromRGBO(212, 255, 206, 1);
    } else if (rule.contains('во время еды')) {
      return const Color.fromRGBO(206, 233, 255, 1);
    } else {
      return const Color.fromRGBO(212, 255, 206, 1);
    }
  }

  static Color getTextColor(String foodRule) {
    final rule = foodRule.toLowerCase();
    if (rule.contains('до еды') || rule.contains('натощак')) {
      return const Color.fromRGBO(65, 20, 0, 1);
    } else if (rule.contains('после еды')) {
      return const Color.fromRGBO(0, 65, 15, 1);
    } else if (rule.contains('во время еды')) {
      return const Color.fromRGBO(0, 18, 65, 1);
    } else {
      return const Color.fromRGBO(0, 65, 15, 1);
    }
  }
}