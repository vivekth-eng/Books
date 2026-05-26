import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libri_stack/core/providers/core_providers.dart';
import 'package:libri_stack/features/auth/presentation/providers/auth_provider.dart';
import 'package:libri_stack/features/auth/presentation/login_screen.dart';
import 'package:libri_stack/features/book/presentation/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set image cache limits for smooth UI rendering
  PaintingBinding.instance.imageCache.maximumSize = 50 * 1024 * 1024;

  // Initialize SharedPreferences local storage
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const LibriStackApp(),
    ),
  );
}

class LibriStackApp extends ConsumerWidget {
  const LibriStackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return MaterialApp(
      title: 'LibriStack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: authState.isAuthenticated
          ? const DashboardScreen()
          : const LoginScreen(),
    );
  }
}
