import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: c.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 60, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Brand mark
              Text(
                'tue',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Belay Buddy',
                style: GoogleFonts.inter(
                  fontSize: 44,
                  fontWeight: FontWeight.w600,
                  color: c.ink,
                  height: 1.0,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'who’s on the wall tonight?',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: c.textSecondary,
                  height: 1.4,
                ),
              ),
              const Spacer(),

              // Lime status pill — the brand bet on the splash
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: c.lime,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.ink, width: 1.5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'lime means someone is on the wall.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: c.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Enter button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.go('/now'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: c.ink,
                    border: Border.all(color: c.ink, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'enter',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.canvas,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'no account needed — demo',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: c.textDisabled,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
