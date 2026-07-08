class Todo {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool reminderEnabled;
  final int? reminderOffset;
  final String? reminderUnit;
  final int? reminderTimeMinutes;
  final bool recurrenceEnabled;
  final int? recurrenceInterval;
  final String? recurrenceUnit;
  final String? listId;
  final String? originalTodoId;

  // Soft delete fields
  final bool isDeleted;
  final DateTime? deletedAt;

  // Sync tracking fields
  final bool needsSync;
  final DateTime? lastSyncedAt;
  final String? deviceId;

  const Todo({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.isCompleted,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.reminderEnabled,
    this.reminderOffset,
    this.reminderUnit,
    this.reminderTimeMinutes,
    required this.recurrenceEnabled,
    this.recurrenceInterval,
    this.recurrenceUnit,
    this.listId,
    this.originalTodoId,
    this.isDeleted = false,
    this.deletedAt,
    this.needsSync = true,
    this.lastSyncedAt,
    this.deviceId,
  });

  // Sentinel distinguishing "not passed" from "explicitly passed null" for
  // nullable copyWith params below -- `field ?? this.field` can't tell
  // those apart, so an explicit null (meant to clear the field) would
  // silently fall back to the old value instead.
  static const _unset = Object();

  Todo copyWith({
    String? id,
    String? title,
    Object? description = _unset,
    Object? dueDate = _unset,
    bool? isCompleted,
    Object? completedAt = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? reminderEnabled,
    Object? reminderOffset = _unset,
    Object? reminderUnit = _unset,
    Object? reminderTimeMinutes = _unset,
    bool? recurrenceEnabled,
    Object? recurrenceInterval = _unset,
    Object? recurrenceUnit = _unset,
    Object? listId = _unset,
    Object? originalTodoId = _unset,
    bool? isDeleted,
    Object? deletedAt = _unset,
    bool? needsSync,
    Object? lastSyncedAt = _unset,
    Object? deviceId = _unset,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: identical(description, _unset) ? this.description : description as String?,
      dueDate: identical(dueDate, _unset) ? this.dueDate : dueDate as DateTime?,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: identical(completedAt, _unset) ? this.completedAt : completedAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderOffset:
          identical(reminderOffset, _unset) ? this.reminderOffset : reminderOffset as int?,
      reminderUnit:
          identical(reminderUnit, _unset) ? this.reminderUnit : reminderUnit as String?,
      reminderTimeMinutes: identical(reminderTimeMinutes, _unset)
          ? this.reminderTimeMinutes
          : reminderTimeMinutes as int?,
      recurrenceEnabled: recurrenceEnabled ?? this.recurrenceEnabled,
      recurrenceInterval: identical(recurrenceInterval, _unset)
          ? this.recurrenceInterval
          : recurrenceInterval as int?,
      recurrenceUnit:
          identical(recurrenceUnit, _unset) ? this.recurrenceUnit : recurrenceUnit as String?,
      listId: identical(listId, _unset) ? this.listId : listId as String?,
      originalTodoId: identical(originalTodoId, _unset)
          ? this.originalTodoId
          : originalTodoId as String?,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: identical(deletedAt, _unset) ? this.deletedAt : deletedAt as DateTime?,
      needsSync: needsSync ?? this.needsSync,
      lastSyncedAt:
          identical(lastSyncedAt, _unset) ? this.lastSyncedAt : lastSyncedAt as DateTime?,
      deviceId: identical(deviceId, _unset) ? this.deviceId : deviceId as String?,
    );
  }

  /// True if this task's due date's calendar day is before today and it's
  /// not yet completed.
  ///
  /// Compares calendar days, not exact instants — due dates are date-only
  /// in this app (no time-of-day is ever captured for them), so a task due
  /// "today" should read as due today, not overdue, until the day is over.
  ///
  /// Independent of reminders — a task can be overdue with no reminder ever
  /// configured, or have its reminder fire well before it's actually
  /// overdue (e.g. "remind me 3 days before this is due").
  bool get isOverdue {
    if (isCompleted || dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return dueDay.isBefore(today);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, isCompleted: $isCompleted}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'reminderEnabled': reminderEnabled,
      'reminderOffset': reminderOffset,
      'reminderUnit': reminderUnit,
      'reminderTimeMinutes': reminderTimeMinutes,
      'recurrenceEnabled': recurrenceEnabled,
      'recurrenceInterval': recurrenceInterval,
      'recurrenceUnit': recurrenceUnit,
      'listId': listId,
      'originalTodoId': originalTodoId,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'needsSync': needsSync,
      'lastSyncedAt': lastSyncedAt?.millisecondsSinceEpoch,
      'deviceId': deviceId,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
          : null,
      isCompleted: map['isCompleted'] as bool? ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      reminderEnabled: map['reminderEnabled'] as bool? ?? false,
      reminderOffset: map['reminderOffset'] as int?,
      reminderUnit: map['reminderUnit'] as String?,
      reminderTimeMinutes: map['reminderTimeMinutes'] as int?,
      recurrenceEnabled: map['recurrenceEnabled'] as bool? ?? false,
      recurrenceInterval: map['recurrenceInterval'] as int?,
      recurrenceUnit: map['recurrenceUnit'] as String?,
      listId: map['listId'] as String?,
      originalTodoId: map['originalTodoId'] as String?,
      isDeleted: map['isDeleted'] as bool? ?? false,
      deletedAt: map['deletedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] as int)
          : null,
      needsSync: map['needsSync'] as bool? ?? true,
      lastSyncedAt: map['lastSyncedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSyncedAt'] as int)
          : null,
      deviceId: map['deviceId'] as String?,
    );
  }
}
