import 'package:flutter/material.dart';
import 'package:hotel_booking/core/router/app_router.dart';
import 'package:hotel_booking/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Booking',
      theme: AppTheme.lightTheme,
      routerConfig: _appRouter.config(),
    );
  }
}
