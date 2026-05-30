import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/features/now/data/now_repository.dart';
import 'package:belay_buddy/src/features/now/domain/now_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// NOW — the hero surface of the redesign.
///
/// Source of truth: docs/design-north-star.md (Version A wireframe).
/// PR #2 uses hardcoded session data inline. A follow-up PR wires it to a
/// real provider hydrated by recurring intent windows + live check-ins.
///
/// Brand rule: lime appears only when a real human is reachable.
/// Live ring, lime left-bar, lime "say you're coming" CTA, lime checkmark on
/// confirmed pairs. Wave buttons (chalk-blue ring, expected) use ink.
class NowScreen extends ConsumerStatefulWidget {
  const NowScreen({super.key});

  @override
  ConsumerState<NowScreen> createState() => _NowScreenState();
}

class _NowScreenState extends ConsumerState<NowScreen> {
  // User ids of climbers the user has confirmed with this session.
  // In-memory only for the preview; will become a provider on Firebase wire-up.
  final Set<String> _confirmed = {};

  void _toggleConfirm(String userId) {
    setState(() {
      if (_confirmed.contains(userId)) {
        _confirmed.remove(userId);
      } else {
        _confirmed.add(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final sessions = ref.watch(tonightSessionsProvider);
    final radar = ref.watch(radarChipsProvider);
    final forwardLoaded = ref.watch(forwardLoadedDayProvider);

    // Venue header is still local — a venueProvider lands with the IA flip
    // when ME → Change home gym becomes the source of truth.
    const venue = _Venue(name: 'Movement Bldr', timeLabel: 'TUE 5:42p');

    return Scaffold(
      backgroundColor: c.canvas,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _TopBar(venue: venue)),
            SliverToBoxAdapter(child: _hairline(c)),
            const SliverToBoxAdapter(
                child: _SectionHeader(text: 'Tonight at your gym')),
            SliverToBoxAdapter(
              child: _CatchRadarRow(chips: radar, confirmed: _confirmed),
            ),
            SliverToBoxAdapter(child: _hairline(c)),
            SliverList.builder(
              itemCount: sessions.length,
              itemBuilder: (context, i) => _SessionCard(
                session: sessions[i],
                isConfirmedByMe: _confirmed.contains(sessions[i].userId),
                onConfirm: () => _toggleConfirm(sessions[i].userId),
              ),
            ),
            if (forwardLoaded != null)
              SliverToBoxAdapter(
                child: _ForwardLoadBlock(day: forwardLoaded),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(child: _DemoModeToggle()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _hairline(AppColorsExtension c) =>
      Container(height: 1.5, color: c.borderColor);
}

// ─── Top bar ────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final _Venue venue;
  const _TopBar({required this.venue});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Text(
            venue.timeLabel,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: c.ink,
              letterSpacing: -0.2,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                venue.name.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: c.ink,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.push('/profile'),
            child: const _AvatarDot(initial: 't', size: 28),
          ),
        ],
      ),
    );
  }
}

// ─── Section header ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    // The one tactile element: handwritten day-of-week marker.
    // Until a real handwriting asset lands we approximate with a slightly
    // italicized JetBrains Mono "TUE" — the smudge goes here later.
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            'TUE',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: c.ink,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Catch radar row ────────────────────────────────────────────────────────

class _CatchRadarRow extends StatelessWidget {
  final List<RadarChip> chips;
  final Set<String> confirmed;
  const _CatchRadarRow({required this.chips, required this.confirmed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, i) => _RadarBubble(
          chip: chips[i],
          confirmedByMe: confirmed.contains(chips[i].initial),
        ),
      ),
    );
  }
}

class _RadarBubble extends StatelessWidget {
  final RadarChip chip;
  final bool confirmedByMe;
  const _RadarBubble({required this.chip, required this.confirmedByMe});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    // confirmedByMe collapses to the confirmed visual regardless of the chip's
    // underlying state — once you've said you're in, the live pip becomes a
    // check.
    final isLive = chip.status == SessionStatus.live && !confirmedByMe;
    final isConfirmed = chip.status == SessionStatus.confirmed || confirmedByMe;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _AvatarDot(
              initial: chip.initial,
              size: 44,
              ringColor: isLive || isConfirmed ? null : c.chalkBlue,
              ringWidth: isLive || isConfirmed ? 0 : 1.5,
            ),
            if (isLive)
              const Positioned(
                right: -2,
                top: -2,
                child: _LimePip(size: 12),
              ),
            if (isConfirmed)
              const Positioned(
                right: -3,
                top: -3,
                child: _LimeCheck(size: 14),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          chip.name,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: c.ink,
          ),
        ),
        Text(
          chip.timeLabel,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            color: c.textSecondary,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}

// ─── Session card ───────────────────────────────────────────────────────────

class _SessionCard extends StatelessWidget {
  final NowSession session;
  final bool isConfirmedByMe;
  final VoidCallback onConfirm;
  const _SessionCard({
    required this.session,
    required this.isConfirmedByMe,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    // A card the user has just confirmed with reads as confirmed, replacing
    // its original live/expected state.
    final isLive = session.status == SessionStatus.live && !isConfirmedByMe;
    final isConfirmed = session.status == SessionStatus.confirmed || isConfirmedByMe;

    final firstName = session.name.split(' ').first;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left rail — lime if reachable, chalk-blue if expected.
            Container(
              width: 3,
              color: isLive || isConfirmed ? c.lime : c.chalkBlue,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SessionHeaderRow(
                      session: session,
                      isConfirmed: isConfirmed,
                    ),
                    if (session.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        session.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: c.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                    if (session.note != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '"${session.note!}"',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: c.ink,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    if (isConfirmedByMe) ...[
                      const SizedBox(height: 8),
                      Text(
                        '$firstName knows.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: c.ink,
                          height: 1.3,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _LimeButton(
                        label: 'you’re in · ${session.timeLabel}',
                        onTap: onConfirm,
                      ),
                    ] else if (isLive) ...[
                      const SizedBox(height: 14),
                      _LimeButton(
                        label: 'say you’re coming  →',
                        onTap: onConfirm,
                      ),
                    ] else if (isConfirmed) ...[
                      const SizedBox(height: 10),
                      const _LinkAction(label: 'chat  →'),
                    ] else ...[
                      const SizedBox(height: 10),
                      _LinkAction(label: 'wave  →', onTap: onConfirm),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionHeaderRow extends StatelessWidget {
  final NowSession session;
  final bool isConfirmed;
  const _SessionHeaderRow({required this.session, required this.isConfirmed});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _AvatarDot(initial: session.initial, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 2,
            children: [
              Text(
                session.name,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: c.ink,
                ),
              ),
              if (isConfirmed) const _LimeCheck(size: 14),
              if (isConfirmed)
                Text(
                  'confirmed with you',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: c.ink,
                  ),
                ),
            ],
          ),
        ),
        Text(
          session.timeLabel,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            color: c.textSecondary,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ─── Atoms ──────────────────────────────────────────────────────────────────

class _AvatarDot extends StatelessWidget {
  final String initial;
  final double size;
  final Color? ringColor;
  final double ringWidth;
  const _AvatarDot({
    required this.initial,
    required this.size,
    this.ringColor,
    this.ringWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.canvas,
        shape: BoxShape.circle,
        border: Border.all(
          color: ringColor ?? c.ink,
          width: ringColor != null ? ringWidth : 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.jetBrainsMono(
          fontSize: size * 0.42,
          fontWeight: FontWeight.w500,
          color: c.ink,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _LimePip extends StatelessWidget {
  final double size;
  const _LimePip({required this.size});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.lime,
        shape: BoxShape.circle,
        border: Border.all(color: c.ink, width: 1.5),
      ),
    );
  }
}

class _LimeCheck extends StatelessWidget {
  final double size;
  const _LimeCheck({required this.size});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.lime,
        shape: BoxShape.circle,
        border: Border.all(color: c.ink, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.check, size: size * 0.65, color: c.ink),
    );
  }
}

class _LimeButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _LimeButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: c.lime,
            border: Border.all(color: c.ink, width: 1.5),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.ink,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _LinkAction({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: c.ink,
          ),
        ),
      ),
    );
  }
}

// Local venue header data. A venueProvider lands with the IA flip.
class _Venue {
  final String name;
  final String timeLabel;
  const _Venue({required this.name, required this.timeLabel});
}

// ─── Forward-load block (sparse-night Version B) ───────────────────────────

class _ForwardLoadBlock extends StatelessWidget {
  final ForwardLoadedDay day;
  const _ForwardLoadBlock({required this.day});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thinking past tonight?',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: c.canvas,
              border: Border.all(color: c.borderColor, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${day.dayLabel}  ${day.windowLabel}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: c.ink,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${day.usualCount} climbers usual',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 1.5, color: c.borderColor),
                const SizedBox(height: 12),
                _PeekRow(peek: day.peek),
                const SizedBox(height: 14),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showRecurringIntentSheet(context, day),
                  child: Text(
                    day.cta,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: c.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRecurringIntentSheet(BuildContext context, ForwardLoadedDay day) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => _RecurringIntentSheet(day: day),
    );
  }
}

class _PeekRow extends StatelessWidget {
  final List<RadarChip> peek;
  const _PeekRow({required this.peek});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: peek.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final chip = peek[i];
          final isReachable = chip.status == SessionStatus.live ||
              chip.status == SessionStatus.confirmed;
          return Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isReachable ? c.lime : c.canvas,
              shape: BoxShape.circle,
              border: Border.all(
                color: isReachable ? c.ink : c.chalkBlue,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              chip.initial,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: c.ink,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RecurringIntentSheet extends StatelessWidget {
  final ForwardLoadedDay day;
  const _RecurringIntentSheet({required this.day});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${day.windowLabel} sound right?',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'we’ll show you on Thursdays in this window.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: c.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _LimeButton(
                  label: 'yes',
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                _LinkAction(
                  label: 'tweak',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dev: density toggle (remove when real data lands) ─────────────────────

class _DemoModeToggle extends ConsumerWidget {
  const _DemoModeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final mode = ref.watch(nowDemoModeProvider);
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final next = mode == NowDemoMode.dense
              ? NowDemoMode.sparse
              : NowDemoMode.dense;
          ref.read(nowDemoModeProvider.notifier).state = next;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            'preview · ${mode == NowDemoMode.dense ? 'dense' : 'sparse'}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: c.textDisabled,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}
