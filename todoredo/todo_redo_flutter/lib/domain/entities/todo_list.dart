import 'package:flutter/material.dart';

class TodoList {
  final String id;
  final String name;
  final Color? color;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Soft delete fields
  final bool isDeleted;
  final DateTime? deletedAt;

  // Sync tracking fields
  final bool needsSync;
  final DateTime? lastSyncedAt;
  final String? deviceId;

  const TodoList({
    required this.id,
    required this.name,
    this.color,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.needsSync = true,
    this.lastSyncedAt,
    this.deviceId,
  });

  TodoList copyWith({
    String? id,
    String? name,
    Color? color,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    bool? needsSync,
    DateTime? lastSyncedAt,
    String? deviceId,
  }) {
    return TodoList(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
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
      other is TodoList && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TodoList{id: $id, name: $name}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorValue': color?.value,
      'icon': icon,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'needsSync': needsSync,
      'lastSyncedAt': lastSyncedAt?.millisecondsSinceEpoch,
      'deviceId': deviceId,
    };
  }

  factory TodoList.fromMap(Map<String, dynamic> map) {
    return TodoList(
      id: map['id'] as String,
      name: map['name'] as String,
      color: map['colorValue'] != null
          ? Color(map['colorValue'] as int)
          : null,
      icon: map['icon'] as String?,
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
