import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CragScheduleScreen extends StatelessWidget {
  final String cragId;
  const CragScheduleScreen({super.key, required this.cragId});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.dullOrange,
        title: Text(
          'COMMUNITY BOARD',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textOnPrimary,
          ),
        ),
        iconTheme: IconThemeData(color: c.textOnPrimary),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 3),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month_outlined,
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
