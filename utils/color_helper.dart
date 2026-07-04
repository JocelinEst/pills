import 'package:flutter/material.dart';

class ColorHelper {
  static Color hexToColor(String? hexCode) {
    if (hexCode == null || hexCode.isEmpty) {
      return const Color(0xFFFFFFFF);
    }
    String hex = hexCode.trim();
    hex = hex.replaceAll('#', '');
    if (hex.length == 3) {
      hex = hex.split('').map((c) => '$c$c').join();
    }
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return const Color(0xFFFFFFFF);
    }
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}