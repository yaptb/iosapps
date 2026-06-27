import 'package:flutter/material.dart';

class IconCatalog {
  static const icons = <IconData>[
    Icons.cake_outlined,
    Icons.favorite_outline,
    Icons.school_outlined,
    Icons.work_outline,
    Icons.beach_access_outlined,
    Icons.flight_takeoff_outlined,
    Icons.celebration_outlined,
    Icons.local_bar_outlined,
    Icons.self_improvement_outlined,
    Icons.fitness_center_outlined,
    Icons.directions_run_outlined,
    Icons.home_outlined,
    Icons.child_friendly_outlined,
    Icons.pets_outlined,
    Icons.savings_outlined,
    Icons.event_outlined,
    Icons.star_outline,
    Icons.local_florist_outlined,
    Icons.music_note_outlined,
    Icons.menu_book_outlined,
    Icons.rocket_launch_outlined,
    Icons.emoji_events_outlined,
    Icons.medical_services_outlined,
    Icons.directions_car_outlined,
  ];

  static IconData find(int codePoint) {
    return icons.firstWhere(
      (i) => i.codePoint == codePoint,
      orElse: () => Icons.event_outlined,
    );
  }
}
