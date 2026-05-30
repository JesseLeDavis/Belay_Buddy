import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
class NowScreen extends ConsumerWidget {
  const NowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;

    // Hardcoded — wired in a later PR.
    const venue = _Venue(name: 'Movement Bldr', timeLabel: 'TUE 5:42p');
    final radar = _mockRadar();
    final sessions = _mockSessions();

    return Scaffold(
      backgroundColor: c.canvas,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _TopBar(venue: venue)),
            SliverToBoxAdapter(child: _hairline(c)),
            const SliverToBoxAdapter(
                child: _SectionHeader(text: 'Tonight at your gym')),
            SliverToBoxAdapter(child: _CatchRadarRow(chips: radar)),
            SliverToBoxAdapter(child: _hairline(c)),
            SliverList.builder(
              itemCount: sessions.length,
              itemBuilder: (context, i) => _SessionCard(session: sessions[i]),
            ),
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
          const _AvatarDot(initial: 't', size: 28),
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
  final List<_RadarChip> chips;
  const _CatchRadarRow({required this.chips});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, i) => _RadarBubble(chip: chips[i]),
      ),
    );
  }
}

class _RadarBubble extends StatelessWidget {
  final _RadarChip chip;
  const _RadarBubble({required this.chip});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isLive = chip.status == _Status.live;
    final isConfirmed = chip.status == _Status.confirmed;

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
  final _Session session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isLive = session.status == _Status.live;
    final isConfirmed = session.status == _Status.confirmed;

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
            // Left rail — lime if reachable, chalk-blue if expected
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
                    _SessionHeaderRow(session: session),
                    const SizedBox(height: 4),
                    Text(
                      session.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: c.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    if (session.tags != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        session.tags!,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: c.textSecondary,
                          letterSpacing: -0.1,
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
                    if (isLive) ...[
                      const SizedBox(height: 14),
                      const _LimeButton(label: 'say you’re coming  →'),
                    ] else if (isConfirmed) ...[
                      const SizedBox(height: 10),
                      const _LinkAction(label: 'chat  →'),
                    ] else ...[
                      const SizedBox(height: 10),
                      const _LinkAction(label: 'wave  →'),
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
  final _Session session;
  const _SessionHeaderRow({required this.session});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isConfirmed = session.status == _Status.confirmed;

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
  const _LimeButton({required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Align(
      alignment: Alignment.centerLeft,
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
    );
  }
}

class _LinkAction extends StatelessWidget {
  final String label;
  const _LinkAction({required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: c.ink,
        ),
      ),
    );
  }
}

// ─── Mock data (PR #2 only — replace with provider in next pass) ────────────

enum _Status { live, confirmed, expected }

class _Venue {
  final String name;
  final String timeLabel;
  const _Venue({required this.name, required this.timeLabel});
}

class _RadarChip {
  final String initial;
  final String name;
  final String timeLabel;
  final _Status status;
  const _RadarChip({
    required this.initial,
    required this.name,
    required this.timeLabel,
    required this.status,
  });
}

class _Session {
  final String initial;
  final String name;
  final String timeLabel;
  final String subtitle;
  final String? tags;
  final String? note;
  final _Status status;
  const _Session({
    required this.initial,
    required this.name,
    required this.timeLabel,
    required this.subtitle,
    this.tags,
    this.note,
    required this.status,
  });
}

List<_RadarChip> _mockRadar() => const [
      _RadarChip(initial: 'm', name: 'Maya', timeLabel: 'HERE', status: _Status.live),
      _RadarChip(initial: 'd', name: 'Dev', timeLabel: '6p', status: _Status.confirmed),
      _RadarChip(initial: 's', name: 'Sam', timeLabel: '7p', status: _Status.expected),
      _RadarChip(initial: 'p', name: 'Priya', timeLabel: '7:30', status: _Status.expected),
    ];

List<_Session> _mockSessions() => const [
      _Session(
        initial: 'm',
        name: 'Maya K.',
        timeLabel: 'til 8:30p',
        subtitle: 'on the wall now',
        tags: 'slab • 5.10s',
        status: _Status.live,
      ),
      _Session(
        initial: 'd',
        name: 'Dev R.',
        timeLabel: 'landing 6:00p',
        subtitle: '',
        note: 'bringing the kilter board beta from sunday',
        status: _Status.confirmed,
      ),
      _Session(
        initial: 's',
        name: 'Sam T.',
        timeLabel: 'around 7p',
        subtitle: 'usually Tuesdays',
        tags: 'overhang • projecting 5.11',
        status: _Status.expected,
      ),
      _Session(
        initial: 'p',
        name: 'Priya M.',
        timeLabel: 'around 7:30p',
        subtitle: 'usually Tuesdays',
        tags: 'ropes • 5.9–5.10',
        status: _Status.expected,
      ),
    ];
