import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/life_timer.dart';
import '../../domain/timer_format.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/icon_catalog.dart';

class TimerEditScreen extends ConsumerStatefulWidget {
  const TimerEditScreen({super.key, this.timerId});

  final String? timerId;

  @override
  ConsumerState<TimerEditScreen> createState() => _TimerEditScreenState();
}

class _TimerEditScreenState extends ConsumerState<TimerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  DateTime _targetDate = _atMidnight(DateTime.now().add(const Duration(days: 30)));

  static DateTime _atMidnight(DateTime d) => DateTime(d.year, d.month, d.day);
  TimerFormat _format = TimerFormat.days;
  Color _color = AccentPalette.colors.first;
  IconData _icon = IconCatalog.icons.first;
  bool _loaded = false;

  bool get _isEdit => widget.timerId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    } else {
      _loaded = true;
    }
  }

  void _loadExisting() {
    final repo = ref.read(timerRepositoryProvider);
    final t = repo.getById(widget.timerId!);
    if (t != null) {
      _labelController.text = t.label;
      _targetDate = _atMidnight(t.targetDate);
      _format = t.format;
      _color = t.color;
      _icon = IconCatalog.find(t.iconCodePoint);
    }
    setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime(now.year - 120),
      lastDate: DateTime(now.year + 120),
    );
    if (picked == null) return;
    setState(() => _targetDate = _atMidnight(picked));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(timerRepositoryProvider);
    final existing = _isEdit ? repo.getById(widget.timerId!) : null;
    final timer = LifeTimer(
      id: widget.timerId ?? const Uuid().v4(),
      label: _labelController.text.trim(),
      targetDate: _targetDate,
      format: _format,
      colorValue: _color.toARGB32(),
      iconCodePoint: _icon.codePoint,
      createdAt: existing?.createdAt ?? DateTime.now(),
      sortOrder: existing?.sortOrder ?? repo.nextSortOrder(),
    );
    await repo.upsert(timer);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit timer' : 'New timer'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [

            _SectionLabel('Label'),
              const SizedBox(height: 8),
                TextFormField(
                    controller: _labelController,
                       decoration: const InputDecoration(
                          hintText: 'e.g. Retirement, Sober since…',
                           ),

              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Add a label' : null,
            ),
            const SizedBox(height: 20),
            _SectionLabel('Target date'),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        DateFormat.yMMMMEEEEd().format(_targetDate),
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      _targetDate.isAfter(DateTime.now()) ? 'Future' : 'Past',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel('Display format'),
            const SizedBox(height: 8),
            SegmentedButton<TimerFormat>(
              segments: TimerFormat.values
                  .map((f) => ButtonSegment(value: f, label: Text(f.label)))
                  .toList(),
              selected: {_format},
              onSelectionChanged: (s) => setState(() => _format = s.first),
            ),
            const SizedBox(height: 24),
            _SectionLabel('Color'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AccentPalette.colors.map((c) {
                final selected = c.toARGB32() == _color.toARGB32();
                return GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 40,
                    height: 40,
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
                            color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _SectionLabel('Icon'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: IconCatalog.icons.map((i) {
                final selected = i.codePoint == _icon.codePoint;
                return GestureDetector(
                  onTap: () => setState(() => _icon = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? _color
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      i,
                      color: selected
                          ? Colors.white
                          : theme.colorScheme.onSurfaceVariant,
                      size: 22,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 36),
            _SaveButton(
              label: _isEdit ? 'Save changes' : 'Create timer',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;
    final button = FilledButton(
      onPressed: onPressed,
      child: Text(label),
    );

    if (!isLandscape) return button;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: media.size.width * 0.25),
        child: button,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
