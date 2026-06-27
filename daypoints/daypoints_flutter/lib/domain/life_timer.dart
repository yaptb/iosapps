import 'package:flutter/material.dart';

import 'timer_format.dart';

@immutable
class LifeTimer {
  const LifeTimer({
    required this.id,
    required this.label,
    required this.targetDate,
    required this.format,
    required this.colorValue,
    required this.iconCodePoint,
    required this.createdAt,
    required this.sortOrder,
  });

  final String id;
  final String label;
  final DateTime targetDate;
  final TimerFormat format;
  final int colorValue;
  final int iconCodePoint;
  final DateTime createdAt;
  final int sortOrder;

  Color get color => Color(colorValue);

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  bool isPast(DateTime now) => !targetDate.isAfter(now);

  LifeTimer copyWith({
    String? label,
    DateTime? targetDate,
    TimerFormat? format,
    int? colorValue,
    int? iconCodePoint,
    int? sortOrder,
  }) {
    return LifeTimer(
      id: id,
      label: label ?? this.label,
      targetDate: targetDate ?? this.targetDate,
      format: format ?? this.format,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      createdAt: createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
        'targetDate': targetDate.toIso8601String(),
        'format': format.name,
        'colorValue': colorValue,
        'iconCodePoint': iconCodePoint,
        'createdAt': createdAt.toIso8601String(),
        'sortOrder': sortOrder,
      };

  factory LifeTimer.fromMap(Map<dynamic, dynamic> map) {
    final createdAt = DateTime.parse(map['createdAt'] as String);
    return LifeTimer(
      id: map['id'] as String,
      label: map['label'] as String,
      targetDate: DateTime.parse(map['targetDate'] as String),
      format: TimerFormat.values.firstWhere(
        (f) => f.name == map['format'],
        orElse: () => TimerFormat.days,
      ),
      colorValue: map['colorValue'] as int,
      iconCodePoint: map['iconCodePoint'] as int,
      createdAt: createdAt,
      sortOrder: (map['sortOrder'] as int?) ?? createdAt.millisecondsSinceEpoch,
    );
  }
}
