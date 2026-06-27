class Reminder {
  final String id;
  final String todoId;
  final DateTime reminderTime;
  final bool isTriggered;
  final bool isDismissed;
  final bool isSnoozed;
  final DateTime? snoozeUntil;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Soft delete fields
  final bool isDeleted;
  final DateTime? deletedAt;

  // Sync tracking fields
  final bool needsSync;
  final DateTime? lastSyncedAt;
  final String? deviceId;

  const Reminder({
    required this.id,
    required this.todoId,
    required this.reminderTime,
    required this.isTriggered,
    required this.isDismissed,
    required this.isSnoozed,
    this.snoozeUntil,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.needsSync = true,
    this.lastSyncedAt,
    this.deviceId,
  });

  Reminder copyWith({
    String? id,
    String? todoId,
    DateTime? reminderTime,
    bool? isTriggered,
    bool? isDismissed,
    bool? isSnoozed,
    DateTime? snoozeUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    bool? needsSync,
    DateTime? lastSyncedAt,
    String? deviceId,
  }) {
    return Reminder(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      reminderTime: reminderTime ?? this.reminderTime,
      isTriggered: isTriggered ?? this.isTriggered,
      isDismissed: isDismissed ?? this.isDismissed,
      isSnoozed: isSnoozed ?? this.isSnoozed,
      snoozeUntil: snoozeUntil ?? this.snoozeUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      needsSync: needsSync ?? this.needsSync,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reminder && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Reminder{id: $id, todoId: $todoId, reminderTime: $reminderTime}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoId': todoId,
      'reminderTime': reminderTime.millisecondsSinceEpoch,
      'isTriggered': isTriggered,
      'isDismissed': isDismissed,
      'isSnoozed': isSnoozed,
      'snoozeUntil': snoozeUntil?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'needsSync': needsSync,
      'lastSyncedAt': lastSyncedAt?.millisecondsSinceEpoch,
      'deviceId': deviceId,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      todoId: map['todoId'] as String,
      reminderTime: DateTime.fromMillisecondsSinceEpoch(map['reminderTime'] as int),
      isTriggered: map['isTriggered'] as bool? ?? false,
      isDismissed: map['isDismissed'] as bool? ?? false,
      isSnoozed: map['isSnoozed'] as bool? ?? false,
      snoozeUntil: map['snoozeUntil'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['snoozeUntil'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
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
