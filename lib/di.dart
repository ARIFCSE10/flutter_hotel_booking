import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hotel_booking/data/datasources/hotel_local_data_source.dart';
import 'package:hotel_booking/data/datasources/hotel_remote_data_source.dart';
import 'package:hotel_booking/data/models/hotel_model.dart';
import 'package:hotel_booking/data/repositories/hotel_repository_impl.dart';
import 'package:hotel_booking/domain/repositories/hotel_repository.dart';
import 'package:hotel_booking/domain/usecases/get_favorite_hotels_usecase.dart';
import 'package:hotel_booking/domain/usecases/get_hotels_usecase.dart';
import 'package:hotel_booking/domain/usecases/remove_favorite_usecase.dart';
import 'package:hotel_booking/domain/usecases/set_favorite_usecase.dart';
import 'package:hotel_booking/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:hotel_booking/presentation/bloc/hotel/hotel_bloc.dart';

final di = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HotelModelAdapter());

  //Local Data
  final hotelBox = await Hive.openBox<HotelModel>('favorites');

  // Data sources
  di.registerLazySingleton<HotelLocalDataSource>(
    () => HotelLocalDataSourceImpl(hotelBox: hotelBox),
  );

  di.registerLazySingleton<HotelRemoteDataSource>(
    () => HotelRemoteDataSourceMockImpl(),
  );

  // Repository
  di.registerLazySingleton<HotelRepository>(
    () => HotelRepositoryImpl(
      remoteDataSource: di(),
      localDataSource: di(),
    ),
  );

  // Use cases
  di.registerLazySingleton(
    () => GetHotelsUseCase(di()),
  );

  di.registerLazySingleton(
    () => GetFavoriteHotelsUseCase(di()),
  );

  di.registerLazySingleton(
    () => SetFavoriteUseCase(di()),
  );

  di.registerLazySingleton(
    () => RemoveFavoriteUseCase(di()),
  );

  // Bloc
  di.registerSingleton<HotelBloc>(
    HotelBloc(
      getHotelsUseCase: di(),
      setFavoriteUseCase: di(),
      removeFavoriteUseCase: di(),
    ),
  );

  di.registerSingleton<FavoriteBloc>(
    FavoriteBloc(
      getFavoriteHotelsUseCase: di(),
      removeFavoriteUseCase: di(),
      hotelBloc: di(),
    ),
  );
}
