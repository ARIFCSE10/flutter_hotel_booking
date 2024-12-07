part of 'hotel_bloc.dart';

abstract class HotelState extends Equatable {
  const HotelState();
  
  @override
  List<Object> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelLoaded extends HotelState {
  final List<Hotel> hotels;

  const HotelLoaded({required this.hotels});

  @override
  List<Object> get props => [hotels];
}

class HotelError extends HotelState {
  final String message;

  const HotelError({required this.message});

  @override
  List<Object> get props => [message];
}
