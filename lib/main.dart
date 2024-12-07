import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_booking/core/router/app_router.dart';
import 'package:hotel_booking/core/theme/app_theme.dart';
import 'package:hotel_booking/di.dart';
import 'package:hotel_booking/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:hotel_booking/presentation/bloc/hotel/hotel_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HotelBloc>(
          create: (final context) => di<HotelBloc>(),
        ),
        BlocProvider<FavoriteBloc>(
          create: (final context) => di<FavoriteBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Hotel Booking',
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
