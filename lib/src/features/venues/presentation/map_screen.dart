import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/venues/data/venues_repository.dart';
import 'package:belay_buddy/src/features/favorites/data/favorites_repository.dart';
import 'package:belay_buddy/src/features/home_settings/data/home_settings_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/utils/climbing_tags.dart';
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
  GoogleMapController? _mapController;
  bool _hasAnimatedToHome = false;
  BitmapDescriptor? _cragIcon;
  BitmapDescriptor? _gymIcon;

  static const double _collapsedHeight = 220;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final results = await Future.wait([buildCragMarker(), buildGymMarker()]);
    if (mounted) {
      setState(() {
        _cragIcon = results[0];
        _gymIcon = results[1];
      });
    }
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
      backgroundColor: c.canvas,
      appBar: AppBar(
        backgroundColor: c.canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.ink,
        title: Text(
          'Map',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: c.ink,
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      body: cragsAsync.when(
        data: (crags) {
          final favorites = favoritesAsync.valueOrNull ?? [];
          return _buildBody(crags, favorites);
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
        error: (error, stack) => Center(
          child: Text(
            'error: $error',
            style: GoogleFonts.inter(fontSize: 14, color: c.error),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<Crag> crags, List<Crag> favorites) {
    final c = context.appColors;
    final markers = crags
        .map((crag) => Marker(
              markerId: MarkerId(crag.id),
              position:
                  LatLng(crag.location.latitude, crag.location.longitude),
              icon: crag.isGym
                  ? (_gymIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue))
                  : (_cragIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange)),
              onTap: () => context.push('/crag/${crag.id}'),
            ))
        .toSet();

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
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                height: _mapExpanded ? fullHeight : _collapsedHeight,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: c.borderColor, width: 1.5),
                  ),
                ),
                child: Stack(
                  children: [
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
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            setState(() => _mapExpanded = !_mapExpanded),
                        child: Container(
                          decoration: BoxDecoration(
                            color: c.canvas,
                            border: Border(
                              top:
                                  BorderSide(color: c.borderColor, width: 1.5),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _mapExpanded
                                    ? Icons.unfold_less
                                    : Icons.unfold_more,
                                size: 14,
                                color: c.ink,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _mapExpanded ? 'collapse map' : 'expand map',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: c.ink,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.map_outlined,
                                  size: 14, color: c.ink),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Favorites list (hidden when map is fullscreen) ──────────
            if (!_mapExpanded) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                  child: Row(
                    children: [
                      Text(
                        'Favorites',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: c.textSecondary,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${favorites.length}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: c.textDisabled,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (favorites.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Text(
                      'Tap a crag or gym on the map to star it.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, i) => _CragRow(crag: favorites[i]),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ],
        );
      },
    );
  }
}

// ── Crag row ─────────────────────────────────────────────────────────────

class _CragRow extends ConsumerWidget {
  final Crag crag;
  const _CragRow({required this.crag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final vibeTags = ref.watch(cragVibeTagsProvider(crag.id));
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/crag/${crag.id}'),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: c.borderColor, width: 1.5),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              crag.isGym ? Icons.fitness_center : Icons.terrain,
              size: 16,
              color: c.ink,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crag.name,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (crag.region != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      crag.region!,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: c.textSecondary,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                  if (vibeTags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: vibeTags.take(3).map((vt) {
                        final tag = ClimbingTags.getById(vt.tagId);
                        if (tag == null) return const SizedBox.shrink();
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: c.canvas,
                            border: Border.all(color: c.ink, width: 1.5),
                          ),
                          child: Text(
                            vt.count > 1
                                ? '${tag.label.toLowerCase()} ×${vt.count}'
                                : tag.label.toLowerCase(),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: c.ink,
                              letterSpacing: -0.1,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 18, color: c.textDisabled),
          ],
        ),
      ),
    );
  }
}
