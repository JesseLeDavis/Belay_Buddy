import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/auth/presentation/login_screen.dart';
import 'package:belay_buddy/src/features/now/presentation/now_screen.dart';
import 'package:belay_buddy/src/features/venues/presentation/crag_detail_screen.dart';
import 'package:belay_buddy/src/features/posts/presentation/create_post_screen.dart';
import 'package:belay_buddy/src/features/venues/presentation/map_screen.dart';
import 'package:belay_buddy/src/features/messages/presentation/chat_screen.dart';
import 'package:belay_buddy/src/features/messages/presentation/messages_screen.dart';
import 'package:belay_buddy/src/features/profile/presentation/profile_screen.dart';
import 'package:belay_buddy/src/features/profile/presentation/user_profile_screen.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
// Router
// ============================================================

final appRouter = GoRouter(
  initialLocation: '/now',
  routes: [
    // Auth
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Shell -- persists bottom nav bar across tabs
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNavBar(
        location: state.matchedLocation,
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/now',
          builder: (context, state) => const NowScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const MapScreen(),
          routes: [
            GoRoute(
              path: 'crag/:id',
              builder: (context, state) {
                final cragId = state.pathParameters['id']!;
                return CragDetailScreen(cragId: cragId);
              },
              routes: [
                GoRoute(
                  path: 'post',
                  builder: (context, state) {
                    final extra = state.extra;
                    if (extra is Crag) {
                      return CreatePostScreen(crag: extra);
                    }
                    return const _CreatePostFallback();
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/messages',
          builder: (context, state) => const MessagesScreen(),
          routes: [
            GoRoute(
              path: ':conversationId',
              builder: (context, state) {
                final conversationId =
                    state.pathParameters['conversationId']!;
                return ChatScreen(conversationId: conversationId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: ':userId',
              builder: (context, state) {
                final userId = state.pathParameters['userId']!;
                return UserProfileScreen(userId: userId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

// ============================================================
// Shell scaffold — bottom nav
// ============================================================

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  final String location;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
    required this.location,
  });

  // IA-flipped: just NOW + CHATS. ME lives behind the top-right avatar on
  // NOW; the map is reachable via URL or future "Change home gym" sheet
  // launched from ME — both demoted out of the primary nav per the brief.
  static const _tabs = [
    (
      path: '/now',
      icon: Icons.circle_outlined,
      activeIcon: Icons.circle,
      label: 'NOW',
    ),
    (
      path: '/messages',
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'CHATS',
    ),
  ];

  int get _selectedIndex {
    if (location.startsWith('/messages')) return 1;
    return 0; // NOW is the default for /, /now, /crag/*, /profile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _NavBar(
        selectedIndex: _selectedIndex,
        tabs: _tabs,
        onTap: (i) => context.go(_tabs[i].path),
      ),
    );
  }
}

// ============================================================
// Bottom nav bar — Chalk & Static
// ============================================================

class _NavBar extends StatelessWidget {
  final int selectedIndex;
  final List<({String path, IconData icon, IconData activeIcon, String label})>
      tabs;
  final void Function(int) onTap;

  const _NavBar({
    required this.selectedIndex,
    required this.tabs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: c.canvas,
        border: Border(
          top: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(tabs.length, (i) {
            final tab = tabs[i];
            final isSelected = i == selectedIndex;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? tab.activeIcon : tab.icon,
                        size: 20,
                        color: isSelected ? c.ink : c.textDisabled,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.label.toLowerCase(),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? c.ink : c.textDisabled,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================
// Fallback
// ============================================================

class _CreatePostFallback extends StatelessWidget {
  const _CreatePostFallback();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: c.canvas,
      appBar: AppBar(
        backgroundColor: c.canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.ink,
        title: Text(
          'Post',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: c.ink,
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      body: Center(
        child: Text(
          'no crag selected',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: c.error,
          ),
        ),
      ),
    );
  }
}
