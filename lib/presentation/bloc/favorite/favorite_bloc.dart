import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_booking/domain/entities/hotel.dart';
import 'package:hotel_booking/domain/usecases/get_favorite_hotels_usecase.dart';
import 'package:hotel_booking/domain/usecases/remove_favorite_usecase.dart';
import 'package:hotel_booking/presentation/bloc/hotel/hotel_bloc.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoriteHotelsUseCase getFavoriteHotelsUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;
  final HotelBloc hotelBloc;

  FavoriteBloc({
    required this.getFavoriteHotelsUseCase,
    required this.removeFavoriteUseCase,
    required this.hotelBloc,
  }) : super(FavoriteInitial()) {
    on<LoadFavoriteHotels>(_onLoadFavoriteHotels);
    on<RemoveFavoriteHotel>(_onRemoveFavoriteHotel);
    on<UpdateFromHotelBloc>(_onUpdateFromHotelBloc);

    // Listen to HotelBloc state changes
    hotelBloc.stream.listen((final hotelState) {
      if (hotelState is HotelLoaded) {
        final favoriteHotels =
            hotelState.hotels.where((final h) => h.isFavorite).toList();
        add(UpdateFromHotelBloc(hotels: favoriteHotels));
      }
    });
  }

  Future<void> _onLoadFavoriteHotels(
    final LoadFavoriteHotels event,
    final Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    final result = await getFavoriteHotelsUseCase();
    result.fold(
      (final failure) => emit(FavoriteError(message: failure.message)),
      (final hotels) => emit(FavoriteLoaded(hotels: hotels)),
    );
  }

  Future<void> _onRemoveFavoriteHotel(
    final RemoveFavoriteHotel event,
    final Emitter<FavoriteState> emit,
  ) async {
    hotelBloc.add(RemoveFavouriteHotel(hotel: event.hotel));
  }

  void _onUpdateFromHotelBloc(
    final UpdateFromHotelBloc event,
    final Emitter<FavoriteState> emit,
  ) {
    emit(FavoriteLoaded(hotels: event.hotels));
  }
}
