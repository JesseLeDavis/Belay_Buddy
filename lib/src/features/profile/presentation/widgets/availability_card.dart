import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/features/now/data/recurring_intents_repository.dart';
import 'package:belay_buddy/src/features/now/domain/recurring_intent.dart';
import 'package:belay_buddy/src/features/venues/data/venues_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// "My availability" — the current user's recurring intent windows.
/// Lists each as: weekday + time window + crag. Tap an entry's × to remove.
class AvailabilityCard extends ConsumerWidget {
  const AvailabilityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final intents = ref.watch(myIntentsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'My availability',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${intents.length}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: c.textDisabled,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (intents.isEmpty)
          Text(
            'Nothing scheduled yet. On a sparse night, tap '
            '"i’m usually here" to add a weekly window.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: c.textSecondary,
              height: 1.4,
            ),
          )
        else
          ...intents.map((i) => _IntentRow(intent: i)),
      ],
    );
  }
}

class _IntentRow extends ConsumerWidget {
  final RecurringIntent intent;
  const _IntentRow({required this.intent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final crag = ref.watch(cragProvider(intent.cragId)).valueOrNull;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _weekdayPlural(intent.weekday),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatMinute(intent.startMinute)}–${_formatMinute(intent.endMinute)}'
                  '${crag != null ? ' · ${crag.name}' : ''}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: c.textSecondary,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ref
                .read(recurringIntentsProvider.notifier)
                .remove(intent.id),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.close, size: 18, color: c.textDisabled),
            ),
          ),
        ],
      ),
    );
  }
}

const _weekdayPlurals = [
  '',
  'Mondays',
  'Tuesdays',
  'Wednesdays',
  'Thursdays',
  'Fridays',
  'Saturdays',
  'Sundays',
];

String _weekdayPlural(int weekday) => _weekdayPlurals[weekday];

String _formatMinute(int totalMinutes) {
  final hour24 = (totalMinutes ~/ 60) % 24;
  final mins = totalMinutes % 60;
  final h = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
  final m = mins.toString().padLeft(2, '0');
  final ampm = hour24 < 12 ? 'a' : 'p';
  return m == '00' ? '$h$ampm' : '$h:$m$ampm';
}
