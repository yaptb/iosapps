import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/life_timer.dart';
import '../../domain/timer_format.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  bool _seedSamples = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_seedSamples) {
      await _seedSampleTimers();
    }
    await ref.read(onboardingProvider.notifier).complete();
  }

  Future<void> _seedSampleTimers() async {
    final repo = ref.read(timerRepositoryProvider);
    final now = DateTime.now();
    final samples = [
      LifeTimer(
        id: const Uuid().v4(),
        label: 'New Year',
        targetDate: DateTime(now.year + (now.month >= 12 ? 1 : 1), 1, 1),
        format: TimerFormat.days,
        colorValue: const Color(0xFFD81B60).toARGB32(),
        iconCodePoint: Icons.celebration_outlined.codePoint,
        createdAt: now,
        sortOrder: 0,
      ),
      LifeTimer(
        id: const Uuid().v4(),
        label: 'Weekend',
        targetDate: _nextSaturday(now),
        format: TimerFormat.days,
        colorValue: const Color(0xFF1E88E5).toARGB32(),
        iconCodePoint: Icons.beach_access_outlined.codePoint,
        createdAt: now,
        sortOrder: 1,
      ),
    ];
    for (final t in samples) {
      await repo.upsert(t);
    }
  }

  DateTime _nextSaturday(DateTime from) {
    var d = DateTime(from.year, from.month, from.day);
    while (d.weekday != DateTime.saturday || !d.isAfter(from)) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _IntroPage(
        icon: Icons.hourglass_top_outlined,
        title: 'Time, made tangible',
        body:
            "DayPoints turns dates into something you can feel. Track the days until your next milestone — or how far you’ve come.",
      ),
      _IntroPage(
        icon: Icons.event_note_outlined,
        title: 'Countdown or count up',
        body:
            'Future dates count down. Past dates count up. One unified place for every meaningful moment.',
      ),
      _AppearancePage(),
      _SeedPage(
        seedSamples: _seedSamples,
        onToggle: (v) => setState(() => _seedSamples = v),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _page = i),
                children: pages,
              ),
            ),
            _PageIndicator(count: pages.length, current: _page),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  if (_page > 0)
                    TextButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(width: 64),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      if (_page < pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      } else {
                        _finish();
                      }
                    },
                    child: Text(_page < pages.length - 1 ? 'Next' : 'Get started'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(icon,
                size: 44, color: theme.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 32),
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearancePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Make it yours', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(
            'Pick a theme and accent color. You can change these later in settings.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),
          Text('Theme',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('System')),
              ButtonSegment(value: ThemeMode.light, label: Text('Light')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (s) => controller.setThemeMode(s.first),
          ),
          const SizedBox(height: 28),
          Text('Accent',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AccentPalette.colors.map((c) {
              final selected =
                  c.toARGB32() == settings.accentColor.toARGB32();
              return GestureDetector(
                onTap: () => controller.setAccentColor(c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? theme.colorScheme.onSurface
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 22)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SeedPage extends StatelessWidget {
  const _SeedPage({required this.seedSamples, required this.onToggle});
  final bool seedSamples;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ready to start', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(
            'We can drop in a couple of sample timers to show you around — feel free to edit or delete them.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          SwitchListTile.adaptive(
            value: seedSamples,
            onChanged: onToggle,
            title: const Text('Add sample timers'),
            subtitle: const Text('New Year and the next weekend'),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 24 : 8,
          decoration: BoxDecoration(
            color: active
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
