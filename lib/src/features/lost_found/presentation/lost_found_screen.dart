import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LostFoundScreen extends StatelessWidget {
  final String cragId;
  const LostFoundScreen({super.key, required this.cragId});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.amber,
        title: Text(
          'LOST & FOUND BIN',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F0F0F),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F0F0F)),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 3),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 64, color: c.textDisabled),
            const SizedBox(height: AppSpacing.md),
            Text(
              'COMING SOON',
              style: GoogleFonts.spaceMono(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
