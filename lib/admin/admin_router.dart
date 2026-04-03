import 'package:belay_buddy/admin/screens/admin_login_screen.dart';
import 'package:belay_buddy/admin/screens/header_editor_screen.dart';
import 'package:belay_buddy/admin/screens/venue_list_screen.dart';
import 'package:go_router/go_router.dart';

final adminRouter = GoRouter(
  initialLocation: '/venues',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: '/venues',
      builder: (context, state) => const VenueListScreen(),
      routes: [
        GoRoute(
          path: ':id/header',
          builder: (context, state) {
            final venueId = state.pathParameters['id']!;
            return HeaderEditorScreen(venueId: venueId);
          },
        ),
      ],
    ),
  ],
);
