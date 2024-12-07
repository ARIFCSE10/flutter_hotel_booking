part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoriteHotels extends FavoriteEvent {}

class RemoveFavoriteHotel extends FavoriteEvent {
  final Hotel hotel;

  const RemoveFavoriteHotel({required this.hotel});

  @override
  List<Object> get props => [hotel];
}

class UpdateFromHotelBloc extends FavoriteEvent {
  final List<Hotel> hotels;

  const UpdateFromHotelBloc({required this.hotels});

  @override
  List<Object> get props => [hotels];
}
