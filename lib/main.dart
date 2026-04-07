import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BelayBuddyApp()));
}

class BelayBuddyApp extends StatelessWidget {
  const BelayBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Belay Buddy',
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
