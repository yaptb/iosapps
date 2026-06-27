enum TimerFormat {
  days,
  yearsMonthsDays;

  String get label => switch (this) {
        TimerFormat.days => 'Days',
        TimerFormat.yearsMonthsDays => 'Years, months, days',
      };
}
