import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/venues/data/venues_repository.dart';
import 'package:belay_buddy/src/features/favorites/data/favorites_repository.dart';
import 'package:belay_buddy/src/features/home_settings/data/home_settings_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/utils/map_markers.dart';
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
  BitmapDescriptor? _cragIcon;
  BitmapDescriptor? _gymIcon;
  GoogleMapController? _mapController;
  bool _hasAnimatedToHome = false;

  static const double _collapsedHeight = 220;

  bool _markersLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_markersLoaded) {
      _markersLoaded = true;
      _loadMarkerIcons();
    }
  }

  Future<void> _loadMarkerIcons() async {
    final c = context.appColors;
    final crag = await buildCragMarker(
      navy: c.borderColor,
      fill: c.dullOrange,
      iconColor: c.textOnPrimary,
    );
    final gym = await buildGymMarker(
      navy: c.borderColor,
      fill: c.accentBlue,
      iconColor: c.textOnPrimary,
    );
    if (mounted) setState(() { _cragIcon = crag; _gymIcon = gym; });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _animateToHome();
  }

  void _animateToHome() {
    if (_hasAnimatedToHome || _mapController == null) return;

    final settings = ref.read(homeSettingsProvider);
    final homeId = settings.homeGymId ?? settings.homeCragId;
    if (homeId == null) return;

    final crags = ref.read(allCragsProvider).valueOrNull;
    if (crags == null) return;

    final home = crags.where((c) => c.id == homeId).firstOrNull;
    if (home == null) return;

    _hasAnimatedToHome = true;
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(home.location.latitude, home.location.longitude),
          zoom: 12.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final cragsAsync = ref.watch(allCragsProvider);
    final favoritesAsync = ref.watch(favoriteCragsProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.amber,
        title: Text(
          'BELAY BUDDY',
          style: GoogleFonts.spaceMono(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 3),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: c.textPrimary),
            tooltip: 'Search crags',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Crag search coming soon',
                    style: GoogleFonts.cabin(color: c.textOnPrimary, fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: cragsAsync.when(
        data: (crags) {
          final favorites = favoritesAsync.valueOrNull ?? [];
          return _buildBody(crags, favorites);
        },
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: c.dullOrange),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Loading crags...',
                style: GoogleFonts.spaceMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: c.textSecondary,
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: GoogleFonts.cabin(fontSize: 16, color: c.error),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<Crag> crags, List<Crag> favorites) {
    final c = context.appColors;
    final markers = crags.map((crag) => Marker(
      markerId: MarkerId(crag.id),
      position: LatLng(crag.location.latitude, crag.location.longitude),
      icon: crag.isGym
          ? (_gymIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue))
          : (_cragIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)),
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
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: c.borderColor,
                      width: _mapExpanded ? 0 : 2.5,
                    ),
                  ),
                  boxShadow: _mapExpanded
                      ? const []
                      : [
                          BoxShadow(
                            color: c.shadowColor,
                            offset: const Offset(5, 5),
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
                        onMapCreated: _onMapCreated,
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
                          decoration: BoxDecoration(
                            color: c.surface,
                            border: Border(
                              top: BorderSide(
                                  color: c.borderColor, width: 2),
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
                                  color: c.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.map,
                                  size: 14, color: c.textPrimary),
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
                  decoration: BoxDecoration(
                    color: c.background,
                    border: Border(
                      bottom: BorderSide(color: c.borderColor, width: 2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star,
                          color: c.dullOrange, size: 16),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        favorites.isEmpty
                            ? 'NO FAVORITES YET'
                            : '${favorites.where((cr) => !cr.isGym).length} CRAGS · ${favorites.where((cr) => cr.isGym).length} GYMS',
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: c.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'FAVORITES',
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: c.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (favorites.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xl, horizontal: AppSpacing.md),
                    child: Center(
                      child: Text(
                        'Tap a crag or gym on the map to add it to your favorites',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cabin(
                          fontSize: 14,
                          color: c.textDisabled,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _CragCard(crag: favorites[index]),
                      childCount: favorites.length,
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
    final c = context.appColors;
    return GestureDetector(
      onTap: () => context.push('/crag/${crag.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          color: c.surface,
          border: Border.all(color: c.borderColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: c.shadowColor,
              offset: const Offset(5, 5),
              blurRadius: 0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header strip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd,
                vertical: 10,
              ),
              color: crag.isGym ? c.borderColor : c.oliveGreen,
              child: Text(
                crag.isGym ? 'GYM' : 'CRAG',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: crag.isGym ? c.background : c.textOnPrimary,
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
                      color: c.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 12, color: c.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        crag.region ?? 'Unknown Region',
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          color: c.textSecondary,
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
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border:
                              Border.all(color: c.borderColor, width: 2),
                        ),
                        child: Text(
                          t.name.toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
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
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: c.borderColor, width: 2),
                ),
              ),
              child: Text(
                'TAP TO VIEW BOARD →',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
