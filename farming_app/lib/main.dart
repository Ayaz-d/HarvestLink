import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'nav.dart';
import 'data/app_state.dart';

/// Main entry point for the application
///
/// This sets up:
/// - Provider state management (ThemeProvider, CounterProvider)
/// - go_router navigation
/// - Material 3 theming with light/dark modes
void main() {
  // Initialize the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()..loadDummyData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HarvestLink',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,

      // Use context.go() or context.push() to navigate to the routes.
      routerConfig: AppRouter.router,
    );
  }
}
