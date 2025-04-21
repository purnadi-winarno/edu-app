import 'package:flutter/material.dart';

class AppUtils {
  // Calculate score based on progress and lives
  static int calculateScore(double progress, int lives) {
    return (progress * 100 * (lives * 0.25 + 0.75)).toInt();
  }

  // Get level name based on level number
  static String getLevelName(int level) {
    switch (level) {
      case 1:
        return 'Pemula';
      case 2:
        return 'Menengah';
      case 3:
        return 'Lanjutan';
      default:
        return 'Level $level';
    }
  }

  // Get theme color based on level
  static Color getLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
