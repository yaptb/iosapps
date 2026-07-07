import 'dart:developer' as developer;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Loads the IANA timezone database and points `tz.local` at the device's
/// actual timezone.
///
/// Without this, `tz.local` defaults to UTC, and any reminder scheduled via
/// `tz.TZDateTime.from(scheduledDate, tz.local)` gets silently shifted by the
/// device's real UTC offset — which can push the computed fire time into the
/// past, causing the notification to never fire, with no visible error.
Future<void> initializeLocalTimezone() async {
  tz.initializeTimeZones();

  try {
    final deviceTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(deviceTimezone.identifier));
  } catch (e) {
    developer.log(
      'Could not determine device timezone; reminders will use UTC and may '
      'fire at the wrong time.',
      error: e,
    );
  }
}
