part of 'hotel_bloc.dart';

abstract class HotelEvent extends Equatable {
  const HotelEvent();

  @override
  List<Object> get props => [];
}

class LoadHotels extends HotelEvent {}

class SetFavouriteHotelEvent extends HotelEvent {
  final Hotel hotel;

  const SetFavouriteHotelEvent({required this.hotel});

  @override
  List<Object> get props => [hotel];
}

class RemoveFavouriteHotel extends HotelEvent {
  final Hotel hotel;

  const RemoveFavouriteHotel({required this.hotel});

  @override
  List<Object> get props => [hotel];
}
