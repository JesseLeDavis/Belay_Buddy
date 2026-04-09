import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/theme/theme_mode_provider.dart';
import 'package:belay_buddy/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BelayBuddyApp()));
}

class BelayBuddyApp extends ConsumerWidget {
  const BelayBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Belay Buddy',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
