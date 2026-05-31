import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/connections/data/connections_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FindClimbersScreen extends ConsumerWidget {
  const FindClimbersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final usersAsync = ref.watch(discoverableUsersProvider);

    return Scaffold(
      backgroundColor: c.canvas,
      appBar: AppBar(
        backgroundColor: c.canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.ink,
        title: Text(
          'Find climbers',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: c.ink,
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Text(
                'No climbers found.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: users.length,
            itemBuilder: (context, i) => _ClimberRow(user: users[i]),
          );
        },
        loading: () => Center(
          child: Text(
            'loading…',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: c.textSecondary,
            ),
          ),
        ),
        error: (e, _) => Center(
          child: Text(
            'error: $e',
            style: GoogleFonts.inter(fontSize: 14, color: c.error),
          ),
        ),
      ),
    );
  }
}

class _ClimberRow extends ConsumerStatefulWidget {
  final AppUser user;
  const _ClimberRow({required this.user});

  @override
  ConsumerState<_ClimberRow> createState() => _ClimberRowState();
}

class _ClimberRowState extends ConsumerState<_ClimberRow> {
  bool _requestSent = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isConnected = ref.watch(isConnectedProvider(widget.user.uid));
    final hasPending =
        ref.watch(hasPendingRequestFromProvider(widget.user.uid));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/profile/${widget.user.uid}'),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: c.borderColor, width: 1.5),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _AvatarDot(
              initial: widget.user.displayName.isNotEmpty
                  ? widget.user.displayName[0].toLowerCase()
                  : '?',
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.displayName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                  if (widget.user.bio != null &&
                      widget.user.bio!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.user.bio!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: c.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            _PillButton(
              isConnected: isConnected,
              hasPending: hasPending || _requestSent,
              onConnect: () {
                setState(() => _requestSent = true);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'request sent to ${widget.user.displayName}',
                    style:
                        GoogleFonts.inter(color: c.canvas, fontSize: 14),
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final bool isConnected;
  final bool hasPending;
  final VoidCallback onConnect;

  const _PillButton({
    required this.isConnected,
    required this.hasPending,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    late final Color fill;
    late final Color textColor;
    late final Color borderColor;
    late final String label;
    late final VoidCallback? onTap;

    if (isConnected) {
      fill = c.canvas;
      textColor = c.textSecondary;
      borderColor = c.textDisabled;
      label = 'connected';
      onTap = null;
    } else if (hasPending) {
      fill = c.canvas;
      textColor = c.textDisabled;
      borderColor = c.textDisabled;
      label = 'pending';
      onTap = null;
    } else {
      fill = c.ink;
      textColor = c.canvas;
      borderColor = c.ink;
      label = 'connect';
      onTap = onConnect;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _AvatarDot extends StatelessWidget {
  final String initial;
  const _AvatarDot({required this.initial});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: c.canvas,
        shape: BoxShape.circle,
        border: Border.all(color: c.ink, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: c.ink,
        ),
      ),
    );
  }
}
