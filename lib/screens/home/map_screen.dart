import 'package:belay_buddy/models/crag.dart';
import 'package:belay_buddy/providers/firestore_providers.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  bool _mapExpanded = false;

  static const double _collapsedHeight = 220;

  @override
  Widget build(BuildContext context) {
    final cragsAsync = ref.watch(allCragsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.amber,
        title: Text(
          'BELAY BUDDY',
          style: GoogleFonts.spaceMono(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.darkNavy,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.darkNavy, width: 3),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.darkNavy),
            tooltip: 'Search crags',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Crag search coming soon',
                    style: GoogleFonts.cabin(color: Colors.white, fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: cragsAsync.when(
        data: (crags) => _buildBody(crags),
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.dullOrange),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Loading crags...',
                style: GoogleFonts.spaceMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: GoogleFonts.cabin(fontSize: 16, color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<Crag> crags) {
    final markers = crags.map((crag) => Marker(
      markerId: MarkerId(crag.id),
      position: LatLng(crag.location.latitude, crag.location.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      onTap: () => context.push('/crag/${crag.id}'),
    )).toSet();

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullHeight = constraints.maxHeight;

        return CustomScrollView(
          physics: _mapExpanded
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
          slivers: [
            // ── Map panel ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _mapExpanded ? fullHeight : _collapsedHeight,
                margin: _mapExpanded
                    ? EdgeInsets.zero
                    : const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: AppColors.darkNavy,
                      width: _mapExpanded ? 0 : 2.5,
                    ),
                  ),
                  boxShadow: _mapExpanded
                      ? const []
                      : const [
                          BoxShadow(
                            color: AppColors.darkNavy,
                            offset: Offset(5, 5),
                            blurRadius: 0,
                          ),
                        ],
                ),
                child: Stack(
                  children: [
                    // Map fills the container
                    Positioned.fill(
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(39.5, -98.35),
                          zoom: 4.0,
                        ),
                        mapType: MapType.terrain,
                        markers: markers,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                    ),
                    // Expand / collapse strip pinned to bottom
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _mapExpanded = !_mapExpanded),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            border: Border(
                              top: BorderSide(
                                  color: AppColors.darkNavy, width: 2),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            children: [
                              Text(
                                _mapExpanded
                                    ? '▲ COLLAPSE MAP'
                                    : '▼ EXPAND MAP',
                                style: GoogleFonts.spaceMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkNavy,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.map,
                                  size: 14, color: AppColors.darkNavy),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Section header + crag list (hidden when map is full screen)
            if (!_mapExpanded) ...[
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      bottom: BorderSide(color: AppColors.darkNavy, width: 2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.terrain,
                          color: AppColors.darkNavy, size: 16),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${crags.length} CRAGS',
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _CragCard(crag: crags[index]),
                    childCount: crags.length,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

// ── Crag card ─────────────────────────────────────────────────────────────────

class _CragCard extends StatelessWidget {
  final Crag crag;
  const _CragCard({required this.crag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/crag/${crag.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.darkNavy, width: 2.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkNavy,
              offset: Offset(5, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header strip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 4,
                vertical: 10,
              ),
              color: AppColors.oliveGreen,
              child: Text(
                'CRAG',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crag.name,
                    style: GoogleFonts.spaceMono(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        crag.region ?? 'Unknown Region',
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: crag.types.map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.darkNavy, width: 2),
                        ),
                        child: Text(
                          t.name.toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkNavy,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.darkNavy, width: 2),
                ),
              ),
              child: Text(
                'TAP TO VIEW BOARD →',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
