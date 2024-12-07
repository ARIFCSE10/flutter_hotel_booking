import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_booking/domain/entities/hotel.dart';
import 'package:hotel_booking/domain/usecases/get_hotels_usecase.dart';
import 'package:hotel_booking/domain/usecases/remove_favorite_usecase.dart';
import 'package:hotel_booking/domain/usecases/set_favorite_usecase.dart';

part 'hotel_event.dart';
part 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final GetHotelsUseCase getHotelsUseCase;
  final SetFavoriteUseCase setFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;

  HotelBloc({
    required this.getHotelsUseCase,
    required this.setFavoriteUseCase,
    required this.removeFavoriteUseCase,
  }) : super(HotelInitial()) {
    on<LoadHotels>(_onLoadHotels);
    on<SetFavouriteHotelEvent>(_onSetFavorite);
    on<RemoveFavouriteHotel>(_onRemoveFavorite);
  }

  Future<void> _onLoadHotels(
    final LoadHotels event,
    final Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());
    final result = await getHotelsUseCase();
    result.fold(
      (final failure) => emit(HotelError(message: failure.message)),
      (final hotels) => emit(HotelLoaded(hotels: hotels)),
    );
  }

  Future<void> _onSetFavorite(
    final SetFavouriteHotelEvent event,
    final Emitter<HotelState> emit,
  ) async {
    final currentState = state;
    if (currentState is HotelLoaded) {
      final updatedHotels = currentState.hotels.map((final hotel) {
        if (hotel.id == event.hotel.id) {
          return hotel.copyWith(isFavorite: !hotel.isFavorite);
        }
        return hotel;
      }).toList();

      emit(HotelLoaded(hotels: updatedHotels));

      final result = await setFavoriteUseCase(event.hotel);
      result.fold(
        (final failure) {
          emit(HotelError(message: failure.message));
          emit(currentState);
        },
        (final _) {},
      );
    }
  }

  Future<void> _onRemoveFavorite(
    final RemoveFavouriteHotel event,
    final Emitter<HotelState> emit,
  ) async {
    final currentState = state;
    if (currentState is HotelLoaded) {
      final updatedHotels = currentState.hotels.map((final hotel) {
        if (hotel.id == event.hotel.id) {
          return hotel.copyWith(isFavorite: !hotel.isFavorite);
        }
        return hotel;
      }).toList();

      emit(HotelLoaded(hotels: updatedHotels));

      final result = await removeFavoriteUseCase(event.hotel);
      result.fold(
        (final failure) {
          emit(HotelError(message: failure.message));
          emit(currentState);
        },
        (final _) {},
      );
    }
  }

  void toggleFavorite(final Hotel hotel) {
    if (hotel.isFavorite) {
      add(RemoveFavouriteHotel(hotel: hotel));
    } else {
      add(SetFavouriteHotelEvent(hotel: hotel));
    }
  }
}
