import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/product_model.dart';
import '../routes/routes.dart';
import '../widgets/bottom_nav_bar.dart';

// Login
import '../screens/login_screen.dart';

// Common
import '../screens/browse_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/profile_screen.dart';

// Tailor
import '../screens/tailor/tailor_home_screen.dart';
import '../screens/tailor/tailor_orders_screen.dart';
import '../screens/tailor/tailor_analytics_screen.dart';

// Artisan
import '../screens/artisan/artisan_home_screen.dart';
import '../screens/artisan/artisan_products_screen.dart';
import '../screens/artisan/artisan_orders_screen.dart';
import '../screens/artisan/artisan_analytics_screen.dart';
import '../screens/artisan/add_product_screen.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.home,
  redirect: (context, state) {
    final auth = context.read<AuthService>();
    final loggingIn = state.matchedLocation == Routes.login;
    if (!auth.isLoggedIn && !loggingIn) return Routes.login;
    if (auth.isLoggedIn && loggingIn) return Routes.home;
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (_, __) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        // Home — role-aware
        GoRoute(
          path: Routes.home,
          builder: (context, _) {
            final auth = context.read<AuthService>();
            return auth.isTailor ? const TailorHomeScreen() : const ArtisanHomeScreen();
          },
        ),

        // Shared
        GoRoute(path: Routes.browse, builder: (_, __) => const BrowseScreen()),
        GoRoute(path: Routes.profile, builder: (_, __) => const ProfileScreen()),

        // Tailor-specific
        GoRoute(path: Routes.tailorOrders, builder: (_, __) => const TailorOrdersScreen()),
        GoRoute(path: Routes.tailorAnalytics, builder: (_, __) => const TailorAnalyticsScreen()),

        // Artisan-specific
        GoRoute(path: Routes.artisanProducts, builder: (_, __) => const ArtisanProductsScreen()),
        GoRoute(path: Routes.artisanOrders, builder: (_, __) => const ArtisanOrdersScreen()),
        GoRoute(path: Routes.artisanAnalytics, builder: (_, __) => const ArtisanAnalyticsScreen()),
        GoRoute(path: Routes.addProduct, builder: (_, __) => const AddProductScreen()),

        // Product detail (push nav, no shell)
      ],
    ),

    // Product detail outside shell (full-screen)
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final product = state.extra as ProductModel? ??
          demoProducts.firstWhere(
            (p) => p.id == state.pathParameters['id'],
            orElse: () => demoProducts.first,
          );
        return ProductDetailScreen(product: product);
      },
    ),
  ],
);