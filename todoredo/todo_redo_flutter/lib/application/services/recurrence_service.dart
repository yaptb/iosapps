class RecurrenceService {
  RecurrenceService();

  /// Calculate the next due date based on recurrence settings
  DateTime? calculateNextDueDate(
    DateTime? currentDueDate,
    int? recurrenceInterval,
    String? recurrenceUnit,
  ) {
    if (currentDueDate == null || recurrenceInterval == null || recurrenceUnit == null) {
      return null;
    }

    switch (recurrenceUnit.toLowerCase()) {
      case 'days':
        return currentDueDate.add(Duration(days: recurrenceInterval));
      case 'weeks':
        return currentDueDate.add(Duration(days: recurrenceInterval * 7));
      case 'months':
        return DateTime(
          currentDueDate.year,
          currentDueDate.month + recurrenceInterval,
          currentDueDate.day,
          currentDueDate.hour,
          currentDueDate.minute,
          currentDueDate.second,
        );
      case 'years':
        return DateTime(
          currentDueDate.year + recurrenceInterval,
          currentDueDate.month,
          currentDueDate.day,
          currentDueDate.hour,
          currentDueDate.minute,
          currentDueDate.second,
        );
      default:
        return null;
    }
  }
}
