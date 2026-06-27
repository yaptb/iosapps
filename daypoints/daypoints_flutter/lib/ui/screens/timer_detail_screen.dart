import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/timer_display.dart';
import '../../providers/providers.dart';
import 'timer_edit_screen.dart';

class TimerDetailScreen extends ConsumerWidget {
  const TimerDetailScreen({super.key, required this.timerId});

  final String timerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timersAsync = ref.watch(timersStreamProvider);
    final now = ref.watch(tickerProvider).value ?? DateTime.now();
    final theme = Theme.of(context);

    return timersAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (timers) {
        final timer = timers.where((t) => t.id == timerId).firstOrNull;
        if (timer == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Timer not found')),
          );
        }

        final display = TimerDisplay.forTimer(timer, now);
        final accent = timer.color;
        final isDark = theme.brightness == Brightness.dark;
        final bg = Color.alphaBlend(
          accent.withValues(alpha: isDark ? 0.22 : 0.14),
          theme.colorScheme.surface,
        );
        final onAccent = ThemeData.estimateBrightnessForColor(accent) ==
                Brightness.dark
            ? Colors.white
            : Colors.black;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TimerEditScreen(timerId: timer.id),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, ref, timer.id),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: OrientationBuilder(
              builder: (context, orientation) {
                final isLandscape = orientation == Orientation.landscape;
                final iconBox = Hero(
                  tag: 'timer-icon-${timer.id}',
                  child: Container(
                    width: isLandscape ? 56 : 72,
                    height: isLandscape ? 56 : 72,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(isLandscape ? 18 : 22),
                    ),
                    child: Icon(
                      timer.icon,
                      color: onAccent,
                      size: isLandscape ? 28 : 36,
                    ),
                  ),
                );

                final title = Text(
                  timer.label,
                  style: theme.textTheme.headlineMedium,
                  maxLines: isLandscape ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                );

                final remainingLabel = Text(
                  display.isPast
                      ? 'Time elapsed since'
                      : 'Time remaining until',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );

                final dateLabel = Text(
                  DateFormat.yMMMMEEEEd().format(timer.targetDate),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );

                final countdown = AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: Text(
                    display.primary,
                    key: ValueKey(display.primary),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                );

                final centeredCountdown = Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: countdown,
                  ),
                );

                if (isLandscape) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            iconBox,
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  title,
                                  const SizedBox(height: 4),
                                  remainingLabel,
                                  const SizedBox(height: 2),
                                  dateLabel,
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: centeredCountdown),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      iconBox,
                      const SizedBox(height: 28),
                      title,
                      const SizedBox(height: 8),
                      remainingLabel,
                      const SizedBox(height: 4),
                      dateLabel,
                      Expanded(child: centeredCountdown),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete timer?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(timerRepositoryProvider).delete(id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}
