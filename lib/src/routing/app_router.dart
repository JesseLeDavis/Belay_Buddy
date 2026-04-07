import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/auth/presentation/login_screen.dart';
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
  initialLocation: '/',
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
                    final crag = state.extra;
                    if (crag == null) {
                      return const _CreatePostFallback();
                    }
                    return CreatePostScreen(crag: crag as Crag);
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
// Shell scaffold with persistent bottom nav bar
// ============================================================

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  final String location;

  const ScaffoldWithNavBar({super.key, required this.child, required this.location});

  static const _tabs = [
    (path: '/', icon: Icons.map_outlined, activeIcon: Icons.map, label: 'MAP'),
    (
      path: '/messages',
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'MSG',
    ),
    (
      path: '/profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'ME',
    ),
  ];

  int get _selectedIndex {
    if (location.startsWith('/messages')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIdx = _selectedIndex;

    return Scaffold(
      body: child,
      bottomNavigationBar: _NeoNavBar(
        selectedIndex: selectedIdx,
        tabs: _tabs,
        onTap: (index) => context.go(_tabs[index].path),
      ),
    );
  }
}

// -- Custom Neobrutalist nav bar --

class _NeoNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<({String path, IconData icon, IconData activeIcon, String label})>
      tabs;
  final void Function(int) onTap;

  const _NeoNavBar({
    required this.selectedIndex,
    required this.tabs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.darkNavy, width: 3),
        ),
      ),
      child: Row(
          children: List.generate(tabs.length, (i) {
            final tab = tabs[i];
            final isSelected = i == selectedIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.dullOrange : AppColors.surface,
                    border: i < tabs.length - 1
                        ? const Border(
                            right: BorderSide(
                                color: AppColors.darkNavy, width: 2),
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? tab.activeIcon : tab.icon,
                        size: 22,
                        color: isSelected ? Colors.white : AppColors.darkNavy,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tab.label,
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : AppColors.darkNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ),
    );
  }
}

/// Fallback widget shown when CreatePostScreen is reached without a Crag object.
class _CreatePostFallback extends StatelessWidget {
  const _CreatePostFallback();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POST',
          style: GoogleFonts.spaceMono(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.darkNavy,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'ERROR: NO CRAG SELECTED',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }
}
