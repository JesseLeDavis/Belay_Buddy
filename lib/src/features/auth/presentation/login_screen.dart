import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/widgets/retro_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  bool _showCursor = true;

  final List<String> _bootLines = [
    'BELAY_BUDDY OS v1.0',
    '(c) 2026 CragTech Systems',
    '',
    'Initializing chalk bag...... OK',
    'Loading topo maps........... OK',
    'Calibrating carabiners...... OK',
    'Detecting climbing partners.. OK',
    '',
    'SYSTEM READY.',
  ];

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _showCursor = !_showCursor);
          _blinkController.reset();
          _blinkController.forward();
        }
      });
    _blinkController.forward();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top color block — bold orange panel
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + AppSpacing.xl,
              bottom: AppSpacing.xl,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
            ),
            decoration: const BoxDecoration(
              color: AppColors.dullOrange,
              border: Border(
                bottom: BorderSide(color: AppColors.darkNavy, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BELAY\nBUDDY',
                  style: GoogleFonts.spaceMono(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'FIND YOUR CLIMBING PARTNER',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),

          // Bottom form area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  // Status card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColors.darkNavy, width: 2.5),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.darkNavy,
                          offset: Offset(5, 5),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._bootLines.map(
                          (line) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              line,
                              style: GoogleFonts.spaceMono(
                                fontSize: 11,
                                color: line.contains('OK')
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _showCursor ? '_' : ' ',
                          style: GoogleFonts.spaceMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.dullOrange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Login button — full-width, ink bg, orange hard shadow
                  SizedBox(
                    width: double.infinity,
                    child: RetroButton(
                      label: 'Enter',
                      icon: Icons.login,
                      color: AppColors.darkNavy,
                      shadowColor: AppColors.dullOrange,
                      textColor: Colors.white,
                      onPressed: () {
                        context.go('/');
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Text(
                      'NO ACCOUNT NEEDED FOR DEMO',
                      style: GoogleFonts.spaceMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dullOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
