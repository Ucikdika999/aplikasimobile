import 'package:flutter/material.dart';

class StudentBadge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final bool isUnlocked;
  final String? unlockedDate;
  final int xpReward;
  final double progress; // 0.0 to 1.0

  const StudentBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.isUnlocked,
    this.unlockedDate,
    required this.xpReward,
    this.progress = 1.0,
  });
}
