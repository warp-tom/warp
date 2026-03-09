import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://rvogjicagenihdpewmgt.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2b2dqaWNhZ2VuaWhkcGV3bWd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI5MzQxNDUsImV4cCI6MjA4ODUxMDE0NX0.ZRgUlsjKmZtGZvkIUw-Hei8EDugvYczFg7O31sTVTDA',
    );
  } catch (e) {
    debugPrint('Supabase init failed (expected with dummy keys): $e');
  }

  runApp(
    const ProviderScope(
      child: WarpDriverApp(),
    ),
  );
}

class WarpDriverApp extends ConsumerWidget {
  const WarpDriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Warp Driver',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, 
      routerConfig: router,
    );
  }
}
