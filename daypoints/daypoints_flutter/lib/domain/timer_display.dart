import 'package:intl/intl.dart';

import 'life_timer.dart';
import 'timer_format.dart';

class TimerDisplay {
  TimerDisplay({
    required this.primary,
    required this.secondary,
    required this.isPast,
  });

  final String primary;
  final String secondary;
  final bool isPast;

  static TimerDisplay forTimer(LifeTimer timer, DateTime now) {
    final isPast = timer.isPast(now);
    final from = isPast ? timer.targetDate : now;
    final to = isPast ? now : timer.targetDate;
    final totalDays = _daysBetween(from, to);

    switch (timer.format) {
      case TimerFormat.days:
        final formatted = NumberFormat.decimalPattern().format(totalDays);
        return TimerDisplay(
          primary: '$formatted ${totalDays == 1 ? 'day' : 'days'}',
          secondary: isPast ? 'since' : 'remaining',
          isPast: isPast,
        );
      case TimerFormat.yearsMonthsDays:
        final ymd = _yearsMonthsDays(from, to);
        return TimerDisplay(
          primary: _formatYmd(ymd),
          secondary: isPast ? 'since' : 'remaining',
          isPast: isPast,
        );
    }
  }

  static int _daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }

  static _Ymd _yearsMonthsDays(DateTime from, DateTime to) {
    var years = to.year - from.year;
    var months = to.month - from.month;
    var days = to.day - from.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(to.year, to.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    return _Ymd(years, months, days);
  }

  static String _formatYmd(_Ymd ymd) {
    final parts = <String>[];
    if (ymd.years > 0) parts.add('${ymd.years} ${ymd.years == 1 ? 'year' : 'years'}');
    if (ymd.months > 0) parts.add('${ymd.months} ${ymd.months == 1 ? 'month' : 'months'}');
    if (ymd.days > 0 || parts.isEmpty) {
      parts.add('${ymd.days} ${ymd.days == 1 ? 'day' : 'days'}');
    }
    return parts.join(', ');
  }
}

class _Ymd {
  _Ymd(this.years, this.months, this.days);
  final int years;
  final int months;
  final int days;
}
