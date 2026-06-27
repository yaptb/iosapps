// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TodoListsTable extends TodoLists
    with TableInfo<$TodoListsTable, TodoList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorValue,
    icon,
    createdAt,
    updatedAt,
    isDeleted,
    deletedAt,
    needsSync,
    lastSyncedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $TodoListsTable createAlias(String alias) {
    return $TodoListsTable(attachedDatabase, alias);
  }
}

class TodoList extends DataClass implements Insertable<TodoList> {
  final String id;
  final String name;
  final int? colorValue;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime? deletedAt;
  final bool needsSync;
  final DateTime? lastSyncedAt;
  final String? deviceId;
  const TodoList({
    required this.id,
    required this.name,
    this.colorValue,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.deletedAt,
    required this.needsSync,
    this.lastSyncedAt,
    this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  TodoListsCompanion toCompanion(bool nullToAbsent) {
    return TodoListsCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      needsSync: Value(needsSync),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory TodoList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoList(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      icon: serializer.fromJson<String?>(json['icon']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int?>(colorValue),
      'icon': serializer.toJson<String?>(icon),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  TodoList copyWith({
    String? id,
    String? name,
    Value<int?> colorValue = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? needsSync,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
  }) => TodoList(
    id: id ?? this.id,
    name: name ?? this.name,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
    icon: icon.present ? icon.value : this.icon,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    needsSync: needsSync ?? this.needsSync,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  TodoList copyWithCompanion(TodoListsCompanion data) {
    return TodoList(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      icon: data.icon.present ? data.icon.value : this.icon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoList(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    colorValue,
    icon,
    createdAt,
    updatedAt,
    isDeleted,
    deletedAt,
    needsSync,
    lastSyncedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoList &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.icon == this.icon &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.needsSync == this.needsSync &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.deviceId == this.deviceId);
}

class TodoListsCompanion extends UpdateCompanion<TodoList> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> colorValue;
  final Value<String?> icon;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<bool> needsSync;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> deviceId;
  final Value<int> rowid;
  const TodoListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodoListsCompanion.insert({
    required String id,
    required String name,
    this.colorValue = const Value.absent(),
    this.icon = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TodoList> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<String>? icon,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<bool>? needsSync,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (icon != null) 'icon': icon,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodoListsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int?>? colorValue,
    Value<String?>? icon,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<bool>? needsSync,
    Value<DateTime?>? lastSyncedAt,
    Value<String?>? deviceId,
    Value<int>? rowid,
  }) {
    return TodoListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      needsSync: needsSync ?? this.needsSync,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderOffsetMeta = const VerificationMeta(
    'reminderOffset',
  );
  @override
  late final GeneratedColumn<int> reminderOffset = GeneratedColumn<int>(
    'reminder_offset',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderUnitMeta = const VerificationMeta(
    'reminderUnit',
  );
  @override
  late final GeneratedColumn<String> reminderUnit = GeneratedColumn<String>(
    'reminder_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceEnabledMeta = const VerificationMeta(
    'recurrenceEnabled',
  );
  @override
  late final GeneratedColumn<bool> recurrenceEnabled = GeneratedColumn<bool>(
    'recurrence_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("recurrence_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recurrenceIntervalMeta =
      const VerificationMeta('recurrenceInterval');
  @override
  late final GeneratedColumn<int> recurrenceInterval = GeneratedColumn<int>(
    'recurrence_interval',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceUnitMeta = const VerificationMeta(
    'recurrenceUnit',
  );
  @override
  late final GeneratedColumn<String> recurrenceUnit = GeneratedColumn<String>(
    'recurrence_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalTodoIdMeta = const VerificationMeta(
    'originalTodoId',
  );
  @override
  late final GeneratedColumn<String> originalTodoId = GeneratedColumn<String>(
    'original_todo_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    dueDate,
    isCompleted,
    completedAt,
    createdAt,
    updatedAt,
    reminderEnabled,
    reminderOffset,
    reminderUnit,
    recurrenceEnabled,
    recurrenceInterval,
    recurrenceUnit,
    listId,
    originalTodoId,
    isDeleted,
    deletedAt,
    needsSync,
    lastSyncedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Todo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_offset')) {
      context.handle(
        _reminderOffsetMeta,
        reminderOffset.isAcceptableOrUnknown(
          data['reminder_offset']!,
          _reminderOffsetMeta,
        ),
      );
    }
    if (data.containsKey('reminder_unit')) {
      context.handle(
        _reminderUnitMeta,
        reminderUnit.isAcceptableOrUnknown(
          data['reminder_unit']!,
          _reminderUnitMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_enabled')) {
      context.handle(
        _recurrenceEnabledMeta,
        recurrenceEnabled.isAcceptableOrUnknown(
          data['recurrence_enabled']!,
          _recurrenceEnabledMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_interval')) {
      context.handle(
        _recurrenceIntervalMeta,
        recurrenceInterval.isAcceptableOrUnknown(
          data['recurrence_interval']!,
          _recurrenceIntervalMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_unit')) {
      context.handle(
        _recurrenceUnitMeta,
        recurrenceUnit.isAcceptableOrUnknown(
          data['recurrence_unit']!,
          _recurrenceUnitMeta,
        ),
      );
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    }
    if (data.containsKey('original_todo_id')) {
      context.handle(
        _originalTodoIdMeta,
        originalTodoId.isAcceptableOrUnknown(
          data['original_todo_id']!,
          _originalTodoIdMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_offset'],
      ),
      reminderUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_unit'],
      ),
      recurrenceEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}recurrence_enabled'],
      )!,
      recurrenceInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurrence_interval'],
      ),
      recurrenceUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_unit'],
      ),
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      ),
      originalTodoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_todo_id'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
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
  final bool isDeleted;
  final DateTime? deletedAt;
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
    required this.isDeleted,
    this.deletedAt,
    required this.needsSync,
    this.lastSyncedAt,
    this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || reminderOffset != null) {
      map['reminder_offset'] = Variable<int>(reminderOffset);
    }
    if (!nullToAbsent || reminderUnit != null) {
      map['reminder_unit'] = Variable<String>(reminderUnit);
    }
    map['recurrence_enabled'] = Variable<bool>(recurrenceEnabled);
    if (!nullToAbsent || recurrenceInterval != null) {
      map['recurrence_interval'] = Variable<int>(recurrenceInterval);
    }
    if (!nullToAbsent || recurrenceUnit != null) {
      map['recurrence_unit'] = Variable<String>(recurrenceUnit);
    }
    if (!nullToAbsent || listId != null) {
      map['list_id'] = Variable<String>(listId);
    }
    if (!nullToAbsent || originalTodoId != null) {
      map['original_todo_id'] = Variable<String>(originalTodoId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      reminderEnabled: Value(reminderEnabled),
      reminderOffset: reminderOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderOffset),
      reminderUnit: reminderUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderUnit),
      recurrenceEnabled: Value(recurrenceEnabled),
      recurrenceInterval: recurrenceInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceInterval),
      recurrenceUnit: recurrenceUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceUnit),
      listId: listId == null && nullToAbsent
          ? const Value.absent()
          : Value(listId),
      originalTodoId: originalTodoId == null && nullToAbsent
          ? const Value.absent()
          : Value(originalTodoId),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      needsSync: Value(needsSync),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory Todo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderOffset: serializer.fromJson<int?>(json['reminderOffset']),
      reminderUnit: serializer.fromJson<String?>(json['reminderUnit']),
      recurrenceEnabled: serializer.fromJson<bool>(json['recurrenceEnabled']),
      recurrenceInterval: serializer.fromJson<int?>(json['recurrenceInterval']),
      recurrenceUnit: serializer.fromJson<String?>(json['recurrenceUnit']),
      listId: serializer.fromJson<String?>(json['listId']),
      originalTodoId: serializer.fromJson<String?>(json['originalTodoId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderOffset': serializer.toJson<int?>(reminderOffset),
      'reminderUnit': serializer.toJson<String?>(reminderUnit),
      'recurrenceEnabled': serializer.toJson<bool>(recurrenceEnabled),
      'recurrenceInterval': serializer.toJson<int?>(recurrenceInterval),
      'recurrenceUnit': serializer.toJson<String?>(recurrenceUnit),
      'listId': serializer.toJson<String?>(listId),
      'originalTodoId': serializer.toJson<String?>(originalTodoId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? reminderEnabled,
    Value<int?> reminderOffset = const Value.absent(),
    Value<String?> reminderUnit = const Value.absent(),
    bool? recurrenceEnabled,
    Value<int?> recurrenceInterval = const Value.absent(),
    Value<String?> recurrenceUnit = const Value.absent(),
    Value<String?> listId = const Value.absent(),
    Value<String?> originalTodoId = const Value.absent(),
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? needsSync,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
  }) => Todo(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderOffset: reminderOffset.present
        ? reminderOffset.value
        : this.reminderOffset,
    reminderUnit: reminderUnit.present ? reminderUnit.value : this.reminderUnit,
    recurrenceEnabled: recurrenceEnabled ?? this.recurrenceEnabled,
    recurrenceInterval: recurrenceInterval.present
        ? recurrenceInterval.value
        : this.recurrenceInterval,
    recurrenceUnit: recurrenceUnit.present
        ? recurrenceUnit.value
        : this.recurrenceUnit,
    listId: listId.present ? listId.value : this.listId,
    originalTodoId: originalTodoId.present
        ? originalTodoId.value
        : this.originalTodoId,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    needsSync: needsSync ?? this.needsSync,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderOffset: data.reminderOffset.present
          ? data.reminderOffset.value
          : this.reminderOffset,
      reminderUnit: data.reminderUnit.present
          ? data.reminderUnit.value
          : this.reminderUnit,
      recurrenceEnabled: data.recurrenceEnabled.present
          ? data.recurrenceEnabled.value
          : this.recurrenceEnabled,
      recurrenceInterval: data.recurrenceInterval.present
          ? data.recurrenceInterval.value
          : this.recurrenceInterval,
      recurrenceUnit: data.recurrenceUnit.present
          ? data.recurrenceUnit.value
          : this.recurrenceUnit,
      listId: data.listId.present ? data.listId.value : this.listId,
      originalTodoId: data.originalTodoId.present
          ? data.originalTodoId.value
          : this.originalTodoId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderOffset: $reminderOffset, ')
          ..write('reminderUnit: $reminderUnit, ')
          ..write('recurrenceEnabled: $recurrenceEnabled, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('recurrenceUnit: $recurrenceUnit, ')
          ..write('listId: $listId, ')
          ..write('originalTodoId: $originalTodoId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    description,
    dueDate,
    isCompleted,
    completedAt,
    createdAt,
    updatedAt,
    reminderEnabled,
    reminderOffset,
    reminderUnit,
    recurrenceEnabled,
    recurrenceInterval,
    recurrenceUnit,
    listId,
    originalTodoId,
    isDeleted,
    deletedAt,
    needsSync,
    lastSyncedAt,
    deviceId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderOffset == this.reminderOffset &&
          other.reminderUnit == this.reminderUnit &&
          other.recurrenceEnabled == this.recurrenceEnabled &&
          other.recurrenceInterval == this.recurrenceInterval &&
          other.recurrenceUnit == this.recurrenceUnit &&
          other.listId == this.listId &&
          other.originalTodoId == this.originalTodoId &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.needsSync == this.needsSync &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.deviceId == this.deviceId);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime?> dueDate;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> reminderEnabled;
  final Value<int?> reminderOffset;
  final Value<String?> reminderUnit;
  final Value<bool> recurrenceEnabled;
  final Value<int?> recurrenceInterval;
  final Value<String?> recurrenceUnit;
  final Value<String?> listId;
  final Value<String?> originalTodoId;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<bool> needsSync;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> deviceId;
  final Value<int> rowid;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderOffset = const Value.absent(),
    this.reminderUnit = const Value.absent(),
    this.recurrenceEnabled = const Value.absent(),
    this.recurrenceInterval = const Value.absent(),
    this.recurrenceUnit = const Value.absent(),
    this.listId = const Value.absent(),
    this.originalTodoId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodosCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.reminderEnabled = const Value.absent(),
    this.reminderOffset = const Value.absent(),
    this.reminderUnit = const Value.absent(),
    this.recurrenceEnabled = const Value.absent(),
    this.recurrenceInterval = const Value.absent(),
    this.recurrenceUnit = const Value.absent(),
    this.listId = const Value.absent(),
    this.originalTodoId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Todo> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? reminderEnabled,
    Expression<int>? reminderOffset,
    Expression<String>? reminderUnit,
    Expression<bool>? recurrenceEnabled,
    Expression<int>? recurrenceInterval,
    Expression<String>? recurrenceUnit,
    Expression<String>? listId,
    Expression<String>? originalTodoId,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<bool>? needsSync,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderOffset != null) 'reminder_offset': reminderOffset,
      if (reminderUnit != null) 'reminder_unit': reminderUnit,
      if (recurrenceEnabled != null) 'recurrence_enabled': recurrenceEnabled,
      if (recurrenceInterval != null) 'recurrence_interval': recurrenceInterval,
      if (recurrenceUnit != null) 'recurrence_unit': recurrenceUnit,
      if (listId != null) 'list_id': listId,
      if (originalTodoId != null) 'original_todo_id': originalTodoId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodosCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime?>? dueDate,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? reminderEnabled,
    Value<int?>? reminderOffset,
    Value<String?>? reminderUnit,
    Value<bool>? recurrenceEnabled,
    Value<int?>? recurrenceInterval,
    Value<String?>? recurrenceUnit,
    Value<String?>? listId,
    Value<String?>? originalTodoId,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<bool>? needsSync,
    Value<DateTime?>? lastSyncedAt,
    Value<String?>? deviceId,
    Value<int>? rowid,
  }) {
    return TodosCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderOffset.present) {
      map['reminder_offset'] = Variable<int>(reminderOffset.value);
    }
    if (reminderUnit.present) {
      map['reminder_unit'] = Variable<String>(reminderUnit.value);
    }
    if (recurrenceEnabled.present) {
      map['recurrence_enabled'] = Variable<bool>(recurrenceEnabled.value);
    }
    if (recurrenceInterval.present) {
      map['recurrence_interval'] = Variable<int>(recurrenceInterval.value);
    }
    if (recurrenceUnit.present) {
      map['recurrence_unit'] = Variable<String>(recurrenceUnit.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (originalTodoId.present) {
      map['original_todo_id'] = Variable<String>(originalTodoId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderOffset: $reminderOffset, ')
          ..write('reminderUnit: $reminderUnit, ')
          ..write('recurrenceEnabled: $recurrenceEnabled, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('recurrenceUnit: $recurrenceUnit, ')
          ..write('listId: $listId, ')
          ..write('originalTodoId: $originalTodoId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<String> todoId = GeneratedColumn<String>(
    'todo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<DateTime> reminderTime = GeneratedColumn<DateTime>(
    'reminder_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isTriggeredMeta = const VerificationMeta(
    'isTriggered',
  );
  @override
  late final GeneratedColumn<bool> isTriggered = GeneratedColumn<bool>(
    'is_triggered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_triggered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDismissedMeta = const VerificationMeta(
    'isDismissed',
  );
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
    'is_dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSnoozedMeta = const VerificationMeta(
    'isSnoozed',
  );
  @override
  late final GeneratedColumn<bool> isSnoozed = GeneratedColumn<bool>(
    'is_snoozed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_snoozed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _snoozeUntilMeta = const VerificationMeta(
    'snoozeUntil',
  );
  @override
  late final GeneratedColumn<DateTime> snoozeUntil = GeneratedColumn<DateTime>(
    'snooze_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    todoId,
    reminderTime,
    isTriggered,
    isDismissed,
    isSnoozed,
    snoozeUntil,
    createdAt,
    updatedAt,
    isDeleted,
    deletedAt,
    needsSync,
    lastSyncedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('todo_id')) {
      context.handle(
        _todoIdMeta,
        todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_todoIdMeta);
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reminderTimeMeta);
    }
    if (data.containsKey('is_triggered')) {
      context.handle(
        _isTriggeredMeta,
        isTriggered.isAcceptableOrUnknown(
          data['is_triggered']!,
          _isTriggeredMeta,
        ),
      );
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
        _isDismissedMeta,
        isDismissed.isAcceptableOrUnknown(
          data['is_dismissed']!,
          _isDismissedMeta,
        ),
      );
    }
    if (data.containsKey('is_snoozed')) {
      context.handle(
        _isSnoozedMeta,
        isSnoozed.isAcceptableOrUnknown(data['is_snoozed']!, _isSnoozedMeta),
      );
    }
    if (data.containsKey('snooze_until')) {
      context.handle(
        _snoozeUntilMeta,
        snoozeUntil.isAcceptableOrUnknown(
          data['snooze_until']!,
          _snoozeUntilMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      todoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}todo_id'],
      )!,
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_time'],
      )!,
      isTriggered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_triggered'],
      )!,
      isDismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dismissed'],
      )!,
      isSnoozed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_snoozed'],
      )!,
      snoozeUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}snooze_until'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String todoId;
  final DateTime reminderTime;
  final bool isTriggered;
  final bool isDismissed;
  final bool isSnoozed;
  final DateTime? snoozeUntil;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime? deletedAt;
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
    required this.isDeleted,
    this.deletedAt,
    required this.needsSync,
    this.lastSyncedAt,
    this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['todo_id'] = Variable<String>(todoId);
    map['reminder_time'] = Variable<DateTime>(reminderTime);
    map['is_triggered'] = Variable<bool>(isTriggered);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    map['is_snoozed'] = Variable<bool>(isSnoozed);
    if (!nullToAbsent || snoozeUntil != null) {
      map['snooze_until'] = Variable<DateTime>(snoozeUntil);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      todoId: Value(todoId),
      reminderTime: Value(reminderTime),
      isTriggered: Value(isTriggered),
      isDismissed: Value(isDismissed),
      isSnoozed: Value(isSnoozed),
      snoozeUntil: snoozeUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozeUntil),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      needsSync: Value(needsSync),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      todoId: serializer.fromJson<String>(json['todoId']),
      reminderTime: serializer.fromJson<DateTime>(json['reminderTime']),
      isTriggered: serializer.fromJson<bool>(json['isTriggered']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
      isSnoozed: serializer.fromJson<bool>(json['isSnoozed']),
      snoozeUntil: serializer.fromJson<DateTime?>(json['snoozeUntil']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'todoId': serializer.toJson<String>(todoId),
      'reminderTime': serializer.toJson<DateTime>(reminderTime),
      'isTriggered': serializer.toJson<bool>(isTriggered),
      'isDismissed': serializer.toJson<bool>(isDismissed),
      'isSnoozed': serializer.toJson<bool>(isSnoozed),
      'snoozeUntil': serializer.toJson<DateTime?>(snoozeUntil),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  Reminder copyWith({
    String? id,
    String? todoId,
    DateTime? reminderTime,
    bool? isTriggered,
    bool? isDismissed,
    bool? isSnoozed,
    Value<DateTime?> snoozeUntil = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? needsSync,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
  }) => Reminder(
    id: id ?? this.id,
    todoId: todoId ?? this.todoId,
    reminderTime: reminderTime ?? this.reminderTime,
    isTriggered: isTriggered ?? this.isTriggered,
    isDismissed: isDismissed ?? this.isDismissed,
    isSnoozed: isSnoozed ?? this.isSnoozed,
    snoozeUntil: snoozeUntil.present ? snoozeUntil.value : this.snoozeUntil,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    needsSync: needsSync ?? this.needsSync,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      todoId: data.todoId.present ? data.todoId.value : this.todoId,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      isTriggered: data.isTriggered.present
          ? data.isTriggered.value
          : this.isTriggered,
      isDismissed: data.isDismissed.present
          ? data.isDismissed.value
          : this.isDismissed,
      isSnoozed: data.isSnoozed.present ? data.isSnoozed.value : this.isSnoozed,
      snoozeUntil: data.snoozeUntil.present
          ? data.snoozeUntil.value
          : this.snoozeUntil,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('isTriggered: $isTriggered, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('isSnoozed: $isSnoozed, ')
          ..write('snoozeUntil: $snoozeUntil, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    todoId,
    reminderTime,
    isTriggered,
    isDismissed,
    isSnoozed,
    snoozeUntil,
    createdAt,
    updatedAt,
    isDeleted,
    deletedAt,
    needsSync,
    lastSyncedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.todoId == this.todoId &&
          other.reminderTime == this.reminderTime &&
          other.isTriggered == this.isTriggered &&
          other.isDismissed == this.isDismissed &&
          other.isSnoozed == this.isSnoozed &&
          other.snoozeUntil == this.snoozeUntil &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.needsSync == this.needsSync &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.deviceId == this.deviceId);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> todoId;
  final Value<DateTime> reminderTime;
  final Value<bool> isTriggered;
  final Value<bool> isDismissed;
  final Value<bool> isSnoozed;
  final Value<DateTime?> snoozeUntil;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<bool> needsSync;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> deviceId;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.todoId = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.isTriggered = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.isSnoozed = const Value.absent(),
    this.snoozeUntil = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String todoId,
    required DateTime reminderTime,
    this.isTriggered = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.isSnoozed = const Value.absent(),
    this.snoozeUntil = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       todoId = Value(todoId),
       reminderTime = Value(reminderTime),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? todoId,
    Expression<DateTime>? reminderTime,
    Expression<bool>? isTriggered,
    Expression<bool>? isDismissed,
    Expression<bool>? isSnoozed,
    Expression<DateTime>? snoozeUntil,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<bool>? needsSync,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todoId != null) 'todo_id': todoId,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (isTriggered != null) 'is_triggered': isTriggered,
      if (isDismissed != null) 'is_dismissed': isDismissed,
      if (isSnoozed != null) 'is_snoozed': isSnoozed,
      if (snoozeUntil != null) 'snooze_until': snoozeUntil,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? todoId,
    Value<DateTime>? reminderTime,
    Value<bool>? isTriggered,
    Value<bool>? isDismissed,
    Value<bool>? isSnoozed,
    Value<DateTime?>? snoozeUntil,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<bool>? needsSync,
    Value<DateTime?>? lastSyncedAt,
    Value<String?>? deviceId,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<String>(todoId.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<DateTime>(reminderTime.value);
    }
    if (isTriggered.present) {
      map['is_triggered'] = Variable<bool>(isTriggered.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    if (isSnoozed.present) {
      map['is_snoozed'] = Variable<bool>(isSnoozed.value);
    }
    if (snoozeUntil.present) {
      map['snooze_until'] = Variable<DateTime>(snoozeUntil.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('isTriggered: $isTriggered, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('isSnoozed: $isSnoozed, ')
          ..write('snoozeUntil: $snoozeUntil, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodoListsTable todoLists = $TodoListsTable(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    todoLists,
    todos,
    reminders,
  ];
}

typedef $$TodoListsTableCreateCompanionBuilder =
    TodoListsCompanion Function({
      required String id,
      required String name,
      Value<int?> colorValue,
      Value<String?> icon,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncedAt,
      Value<String?> deviceId,
      Value<int> rowid,
    });
typedef $$TodoListsTableUpdateCompanionBuilder =
    TodoListsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int?> colorValue,
      Value<String?> icon,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncedAt,
      Value<String?> deviceId,
      Value<int> rowid,
    });

class $$TodoListsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoListsTable> {
  $$TodoListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodoListsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoListsTable> {
  $$TodoListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodoListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoListsTable> {
  $$TodoListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$TodoListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoListsTable,
          TodoList,
          $$TodoListsTableFilterComposer,
          $$TodoListsTableOrderingComposer,
          $$TodoListsTableAnnotationComposer,
          $$TodoListsTableCreateCompanionBuilder,
          $$TodoListsTableUpdateCompanionBuilder,
          (TodoList, BaseReferences<_$AppDatabase, $TodoListsTable, TodoList>),
          TodoList,
          PrefetchHooks Function()
        > {
  $$TodoListsTableTableManager(_$AppDatabase db, $TodoListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodoListsCompanion(
                id: id,
                name: name,
                colorValue: colorValue,
                icon: icon,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                needsSync: needsSync,
                lastSyncedAt: lastSyncedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int?> colorValue = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodoListsCompanion.insert(
                id: id,
                name: name,
                colorValue: colorValue,
                icon: icon,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                needsSync: needsSync,
                lastSyncedAt: lastSyncedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodoListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoListsTable,
      TodoList,
      $$TodoListsTableFilterComposer,
      $$TodoListsTableOrderingComposer,
      $$TodoListsTableAnnotationComposer,
      $$TodoListsTableCreateCompanionBuilder,
      $$TodoListsTableUpdateCompanionBuilder,
      (TodoList, BaseReferences<_$AppDatabase, $TodoListsTable, TodoList>),
      TodoList,
      PrefetchHooks Function()
    >;
typedef $$TodosTableCreateCompanionBuilder =
    TodosCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<DateTime?> dueDate,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> reminderEnabled,
      Value<int?> reminderOffset,
      Value<String?> reminderUnit,
      Value<bool> recurrenceEnabled,
      Value<int?> recurrenceInterval,
      Value<String?> recurrenceUnit,
      Value<String?> listId,
      Value<String?> originalTodoId,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncedAt,
      Value<String?> deviceId,
      Value<int> rowid,
    });
typedef $$TodosTableUpdateCompanionBuilder =
    TodosCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<DateTime?> dueDate,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> reminderEnabled,
      Value<int?> reminderOffset,
      Value<String?> reminderUnit,
      Value<bool> recurrenceEnabled,
      Value<int?> recurrenceInterval,
      Value<String?> recurrenceUnit,
      Value<String?> listId,
      Value<String?> originalTodoId,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncedAt,
      Value<String?> deviceId,
      Value<int> rowid,
    });

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderOffset => $composableBuilder(
    column: $table.reminderOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderUnit => $composableBuilder(
    column: $table.reminderUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recurrenceEnabled => $composableBuilder(
    column: $table.recurrenceEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recurrenceInterval => $composableBuilder(
    column: $table.recurrenceInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceUnit => $composableBuilder(
    column: $table.recurrenceUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalTodoId => $composableBuilder(
    column: $table.originalTodoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderOffset => $composableBuilder(
    column: $table.reminderOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderUnit => $composableBuilder(
    column: $table.reminderUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recurrenceEnabled => $composableBuilder(
    column: $table.recurrenceEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurrenceInterval => $composableBuilder(
    column: $table.recurrenceInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceUnit => $composableBuilder(
    column: $table.recurrenceUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalTodoId => $composableBuilder(
    column: $table.originalTodoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderOffset => $composableBuilder(
    column: $table.reminderOffset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderUnit => $composableBuilder(
    column: $table.reminderUnit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get recurrenceEnabled => $composableBuilder(
    column: $table.recurrenceEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recurrenceInterval => $composableBuilder(
    column: $table.recurrenceInterval,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceUnit => $composableBuilder(
    column: $table.recurrenceUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<String> get originalTodoId => $composableBuilder(
    column: $table.originalTodoId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$TodosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodosTable,
          Todo,
          $$TodosTableFilterComposer,
          $$TodosTableOrderingComposer,
          $$TodosTableAnnotationComposer,
          $$TodosTableCreateCompanionBuilder,
          $$TodosTableUpdateCompanionBuilder,
          (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
          Todo,
          PrefetchHooks Function()
        > {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int?> reminderOffset = const Value.absent(),
                Value<String?> reminderUnit = const Value.absent(),
                Value<bool> recurrenceEnabled = const Value.absent(),
                Value<int?> recurrenceInterval = const Value.absent(),
                Value<String?> recurrenceUnit = const Value.absent(),
                Value<String?> listId = const Value.absent(),
                Value<String?> originalTodoId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodosCompanion(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                isCompleted: isCompleted,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                reminderEnabled: reminderEnabled,
                reminderOffset: reminderOffset,
                reminderUnit: reminderUnit,
                recurrenceEnabled: recurrenceEnabled,
                recurrenceInterval: recurrenceInterval,
                recurrenceUnit: recurrenceUnit,
                listId: listId,
                originalTodoId: originalTodoId,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                needsSync: needsSync,
                lastSyncedAt: lastSyncedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int?> reminderOffset = const Value.absent(),
                Value<String?> reminderUnit = const Value.absent(),
                Value<bool> recurrenceEnabled = const Value.absent(),
                Value<int?> recurrenceInterval = const Value.absent(),
                Value<String?> recurrenceUnit = const Value.absent(),
                Value<String?> listId = const Value.absent(),
                Value<String?> originalTodoId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodosCompanion.insert(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                isCompleted: isCompleted,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                reminderEnabled: reminderEnabled,
                reminderOffset: reminderOffset,
                reminderUnit: reminderUnit,
                recurrenceEnabled: recurrenceEnabled,
                recurrenceInterval: recurrenceInterval,
                recurrenceUnit: recurrenceUnit,
                listId: listId,
                originalTodoId: originalTodoId,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                needsSync: needsSync,
                lastSyncedAt: lastSyncedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodosTable,
      Todo,
      $$TodosTableFilterComposer,
      $$TodosTableOrderingComposer,
      $$TodosTableAnnotationComposer,
      $$TodosTableCreateCompanionBuilder,
      $$TodosTableUpdateCompanionBuilder,
      (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
      Todo,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required String todoId,
      required DateTime reminderTime,
      Value<bool> isTriggered,
      Value<bool> isDismissed,
      Value<bool> isSnoozed,
      Value<DateTime?> snoozeUntil,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncedAt,
      Value<String?> deviceId,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<String> todoId,
      Value<DateTime> reminderTime,
      Value<bool> isTriggered,
      Value<bool> isDismissed,
      Value<bool> isSnoozed,
      Value<DateTime?> snoozeUntil,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncedAt,
      Value<String?> deviceId,
      Value<int> rowid,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get todoId => $composableBuilder(
    column: $table.todoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTriggered => $composableBuilder(
    column: $table.isTriggered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSnoozed => $composableBuilder(
    column: $table.isSnoozed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get snoozeUntil => $composableBuilder(
    column: $table.snoozeUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get todoId => $composableBuilder(
    column: $table.todoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTriggered => $composableBuilder(
    column: $table.isTriggered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSnoozed => $composableBuilder(
    column: $table.isSnoozed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get snoozeUntil => $composableBuilder(
    column: $table.snoozeUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get todoId =>
      $composableBuilder(column: $table.todoId, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTriggered => $composableBuilder(
    column: $table.isTriggered,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSnoozed =>
      $composableBuilder(column: $table.isSnoozed, builder: (column) => column);

  GeneratedColumn<DateTime> get snoozeUntil => $composableBuilder(
    column: $table.snoozeUntil,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> todoId = const Value.absent(),
                Value<DateTime> reminderTime = const Value.absent(),
                Value<bool> isTriggered = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                Value<bool> isSnoozed = const Value.absent(),
                Value<DateTime?> snoozeUntil = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                todoId: todoId,
                reminderTime: reminderTime,
                isTriggered: isTriggered,
                isDismissed: isDismissed,
                isSnoozed: isSnoozed,
                snoozeUntil: snoozeUntil,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                needsSync: needsSync,
                lastSyncedAt: lastSyncedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String todoId,
                required DateTime reminderTime,
                Value<bool> isTriggered = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                Value<bool> isSnoozed = const Value.absent(),
                Value<DateTime?> snoozeUntil = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                todoId: todoId,
                reminderTime: reminderTime,
                isTriggered: isTriggered,
                isDismissed: isDismissed,
                isSnoozed: isSnoozed,
                snoozeUntil: snoozeUntil,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                needsSync: needsSync,
                lastSyncedAt: lastSyncedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodoListsTableTableManager get todoLists =>
      $$TodoListsTableTableManager(_db, _db.todoLists);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
