import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LostFoundScreen extends StatelessWidget {
  final String cragId;
  const LostFoundScreen({super.key, required this.cragId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.amber,
        title: Text(
          'LOST & FOUND BIN',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.darkNavy,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.darkNavy),
        shape: const Border(
          bottom: BorderSide(color: AppColors.darkNavy, width: 3),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined,
                size: 64, color: AppColors.textDisabled),
            const SizedBox(height: AppSpacing.md),
            Text(
              'COMING SOON',
              style: GoogleFonts.spaceMono(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
