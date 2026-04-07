import 'package:belay_buddy/admin/widgets/header_preview.dart';
import 'package:belay_buddy/admin/widgets/panel_upload_card.dart';
import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/venues/domain/header_config.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Local editing state for the 6 header panels.
final _editorPanelsProvider =
    StateProvider.family<List<HeaderPanel>, String>((ref, venueId) {
  return List.generate(
    6,
    (i) => HeaderPanel(
      index: i,
      slideDelay: i * 80.0,
    ),
  );
});

class HeaderEditorScreen extends ConsumerWidget {
  final String venueId;

  const HeaderEditorScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with Firestore fetch when going live
    final venue = MockData.getCragById(venueId);
    final panels = ref.watch(_editorPanelsProvider(venueId));

    if (venue == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('NOT FOUND')),
        body: const Center(child: Text('Venue not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          venue.name.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: FilledButton.icon(
              onPressed: () => _handleSave(context, ref, venue, panels),
              icon: const Icon(Icons.save, size: 18),
              label: Text(
                'SAVE',
                style: GoogleFonts.spaceMono(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live preview
            Text(
              'PREVIEW',
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            HeaderPreview(
              venueId: venueId,
              isGym: venue.isGym,
              panels: panels,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Panel upload grid
            Text(
              'PANELS (${venue.isGym ? "GYM" : "CRAG"})',
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return PanelUploadCard(
                      panel: panels[index],
                      isGym: venue.isGym,
                      onAssetChanged: (url) {
                        final updated = List<HeaderPanel>.from(panels);
                        updated[index] = panels[index].copyWith(assetUrl: url);
                        ref.read(_editorPanelsProvider(venueId).notifier).state =
                            updated;
                      },
                      onReset: () {
                        final updated = List<HeaderPanel>.from(panels);
                        updated[index] =
                            panels[index].copyWith(assetUrl: null);
                        ref.read(_editorPanelsProvider(venueId).notifier).state =
                            updated;
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave(
    BuildContext context,
    WidgetRef ref,
    Crag venue,
    List<HeaderPanel> panels,
  ) {
    // TODO: Upload SVGs to Firebase Storage and save HeaderConfig to Firestore
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Header config saved for ${venue.name} (mock — wire Firestore to persist)',
        ),
      ),
    );
  }
}
