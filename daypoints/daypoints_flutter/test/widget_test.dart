import 'package:flutter_test/flutter_test.dart';

import 'package:daypoints/domain/life_timer.dart';
import 'package:daypoints/domain/timer_display.dart';
import 'package:daypoints/domain/timer_format.dart';

LifeTimer _make({required DateTime target, TimerFormat format = TimerFormat.days}) {
  return LifeTimer(
    id: 'id',
    label: 'Test',
    targetDate: target,
    format: format,
    colorValue: 0xFF000000,
    iconCodePoint: 0xe88a,
    createdAt: DateTime(2026, 1, 1),
    sortOrder: 0,
  );
}

void main() {
  group('TimerDisplay.forTimer', () {
    test('future target shows days remaining', () {
      final now = DateTime(2026, 6, 23);
      final timer = _make(target: DateTime(2026, 6, 30));
      final d = TimerDisplay.forTimer(timer, now);
      expect(d.isPast, isFalse);
      expect(d.primary, '7 days');
      expect(d.secondary, 'remaining');
    });

    test('past target shows days since', () {
      final now = DateTime(2026, 6, 23);
      final timer = _make(target: DateTime(2026, 6, 13));
      final d = TimerDisplay.forTimer(timer, now);
      expect(d.isPast, isTrue);
      expect(d.primary, '10 days');
      expect(d.secondary, 'since');
    });

    test('years/months/days format for long spans', () {
      final now = DateTime(2026, 6, 23);
      final timer = _make(
        target: DateTime(2030, 9, 1),
        format: TimerFormat.yearsMonthsDays,
      );
      final d = TimerDisplay.forTimer(timer, now);
      expect(d.primary, '4 years, 2 months, 9 days');
    });

    test('same day shows 0 days', () {
      final now = DateTime(2026, 6, 23, 9);
      final timer = _make(target: DateTime(2026, 6, 23, 18));
      final d = TimerDisplay.forTimer(timer, now);
      expect(d.primary, '0 days');
    });
  });

  group('LifeTimer serialization', () {
    test('roundtrips through map', () {
      final t = _make(target: DateTime(2030, 1, 1));
      final restored = LifeTimer.fromMap(t.toMap());
      expect(restored.id, t.id);
      expect(restored.label, t.label);
      expect(restored.targetDate, t.targetDate);
      expect(restored.format, t.format);
      expect(restored.colorValue, t.colorValue);
      expect(restored.iconCodePoint, t.iconCodePoint);
      expect(restored.sortOrder, t.sortOrder);
    });

    test('legacy maps without sortOrder fall back to createdAt millis', () {
      final t = _make(target: DateTime(2030, 1, 1));
      final map = t.toMap()..remove('sortOrder');
      final restored = LifeTimer.fromMap(map);
      expect(restored.sortOrder, t.createdAt.millisecondsSinceEpoch);
    });
  });
}
