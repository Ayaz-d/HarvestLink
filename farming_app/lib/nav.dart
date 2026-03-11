import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/models.dart';
import 'ui/auth/role_selection_screen.dart';
import 'ui/auth/login_screen.dart';
import 'ui/auth/signup_screen.dart';
import 'ui/auth/otp_screen.dart';
import 'ui/farmer/farmer_main_screen.dart';
import 'ui/customer/customer_main_screen.dart';
import 'ui/customer/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'data/app_state.dart';

class MainScreenWrapper extends StatelessWidget {
  const MainScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (!state.isLoggedIn) {
      return const RoleSelectionScreen();
    }
    return state.isFarmer ? const FarmerMainScreen() : const CustomerMainScreen();
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.roleSelection,
    routes: [
      GoRoute(
        path: AppRoutes.roleSelection,
        name: 'roleSelection',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RoleSelectionScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          final role = state.extra as UserRole? ?? UserRole.farmer;
          return LoginScreen(role: role);
        },
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) {
          final role = state.extra as UserRole? ?? UserRole.farmer;
          return SignupScreen(role: role);
        },
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: 'otp',
        builder: (context, state) {
          final name = state.extra as String? ?? '';
          return OtpScreen(name: name);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          // This route will decide whether to go to Farmer or Customer based on state
          // We will use a wrapper widget
          return const MainScreenWrapper();
        },
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        name: 'productDetail',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailScreen(product: product);
        },
      ),
    ],
  );
}

class AppRoutes {
  static const String roleSelection = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String productDetail = '/product_detail';
}
