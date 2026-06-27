import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/timer_card.dart';
import 'timer_detail_screen.dart';
import 'timer_edit_screen.dart';

class TimerListScreen extends ConsumerWidget {
  const TimerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timersAsync = ref.watch(timersStreamProvider);
    final now = ref.watch(tickerProvider).value ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('DayPoints'),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TimerEditScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New timer'),
      ),
      body: timersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (timers) {
          if (timers.isEmpty) {
            return _EmptyState(
              onCreate: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TimerEditScreen()),
              ),
            );
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: timers.length,
            buildDefaultDragHandles: false,
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  final lift = Curves.easeOut.transform(animation.value);
                  return Transform.scale(
                    scale: 1 + 0.03 * lift,
                    child: Material(
                      color: Colors.transparent,
                      elevation: 8 * lift,
                      shadowColor: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      child: child,
                    ),
                  );
                },
              );
            },
            onReorder: (oldIndex, newIndex) async {
              final ids = timers.map((t) => t.id).toList();
              if (newIndex > oldIndex) newIndex -= 1;
              final moved = ids.removeAt(oldIndex);
              ids.insert(newIndex, moved);
              await ref.read(timerRepositoryProvider).reorder(ids);
            },
            itemBuilder: (context, index) {
              final timer = timers[index];
              return Padding(
                key: ValueKey(timer.id),
                padding: EdgeInsets.only(
                  bottom: index == timers.length - 1 ? 0 : 12,
                ),
                child: ReorderableDelayedDragStartListener(
                  index: index,
                  child: TimerCard(
                    timer: timer,
                    now: now,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TimerDetailScreen(timerId: timer.id),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No timers yet',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a timer for any moment that matters — a goal, an anniversary, or a milestone.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Create your first timer'),
            ),
          ],
        ),
      ),
    );
  }
}
