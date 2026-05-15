import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'services/listing_service.dart';
import 'services/auth_service.dart';
import 'services/sustainability_service.dart';
import 'services/chat_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ListingService()),
        ChangeNotifierProvider(create: (_) => SustainabilityService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      // Rebuild router when auth state changes so the redirect runs again
      child: Consumer<AuthService>(
        builder: (context, auth, _) {
          // Refresh GoRouter redirect on auth changes
          appRouter.refresh();
          return MaterialApp.router(
            title: 'Kutira Kone',
            theme: AppTheme.lightTheme,
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
