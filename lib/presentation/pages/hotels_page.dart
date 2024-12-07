import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_booking/presentation/bloc/hotel/hotel_bloc.dart';
import 'package:hotel_booking/presentation/widgets/hotel_card.dart';

@RoutePage()
class HotelsPage extends StatelessWidget {
  const HotelsPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels'),
      ),
      body: BlocBuilder<HotelBloc, HotelState>(
        builder: (final context, final state) {
          if (state is HotelInitial) {
            context.read<HotelBloc>().add(LoadHotels());
            return const Center(child: CircularProgressIndicator());
          } else if (state is HotelLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HotelLoaded) {
            if (state.hotels.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hotel,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hotels found',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please try again later',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.hotels.length,
              itemBuilder: (final context, final index) {
                final hotel = state.hotels[index];
                return HotelCard(
                  hotel: hotel,
                  onFavoritePressed: () =>
                      context.read<HotelBloc>().toggleFavorite(hotel),
                );
              },
            );
          } else if (state is HotelError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
