import 'dart:async';

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../domain/life_timer.dart';
import 'timer_repository.dart';

class HiveTimerRepository implements TimerRepository {
  static const _boxName = 'timers';

  late final Box<Map> _box;
  final _controller = StreamController<List<LifeTimer>>.broadcast();

  @override
  Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxName);
    _box.listenable().addListener(_emit);
    _emit();
  }

  void _emit() {
    if (_controller.isClosed) return;
    _controller.add(getAll());
  }

  @override
  List<LifeTimer> getAll() {
    final timers = _box.values.map((m) => LifeTimer.fromMap(m)).toList();
    timers.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return timers;
  }

  @override
  int nextSortOrder() {
    final timers = getAll();
    if (timers.isEmpty) return 0;
    return timers.first.sortOrder - 1;
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    for (var i = 0; i < orderedIds.length; i++) {
      final existing = getById(orderedIds[i]);
      if (existing == null) continue;
      if (existing.sortOrder == i) continue;
      await _box.put(existing.id, existing.copyWith(sortOrder: i).toMap());
    }
  }

  @override
  LifeTimer? getById(String id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    return LifeTimer.fromMap(raw);
  }

  @override
  Future<void> upsert(LifeTimer timer) async {
    await _box.put(timer.id, timer.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Stream<List<LifeTimer>> watchAll() async* {
    yield getAll();
    yield* _controller.stream;
  }
}
