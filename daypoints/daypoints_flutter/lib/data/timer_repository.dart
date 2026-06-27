import '../domain/life_timer.dart';

abstract class TimerRepository {
  Future<void> init();
  List<LifeTimer> getAll();
  LifeTimer? getById(String id);
  Future<void> upsert(LifeTimer timer);
  Future<void> delete(String id);
  Future<void> reorder(List<String> orderedIds);
  int nextSortOrder();
  Stream<List<LifeTimer>> watchAll();
}
