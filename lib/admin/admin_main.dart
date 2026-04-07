import 'package:belay_buddy/admin/admin_router.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Firebase.initializeApp() when going live
  runApp(const ProviderScope(child: AdminApp()));
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Belay Buddy Admin',
      theme: AppTheme.light,
      routerConfig: adminRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
