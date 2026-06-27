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

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? reminderEnabled,
    int? reminderOffset,
    String? reminderUnit,
    bool? recurrenceEnabled,
    int? recurrenceInterval,
    String? recurrenceUnit,
    String? listId,
    String? originalTodoId,
    bool? isDeleted,
    DateTime? deletedAt,
    bool? needsSync,
    DateTime? lastSyncedAt,
    String? deviceId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderOffset: reminderOffset ?? this.reminderOffset,
      reminderUnit: reminderUnit ?? this.reminderUnit,
      recurrenceEnabled: recurrenceEnabled ?? this.recurrenceEnabled,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      recurrenceUnit: recurrenceUnit ?? this.recurrenceUnit,
      listId: listId ?? this.listId,
      originalTodoId: originalTodoId ?? this.originalTodoId,
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
