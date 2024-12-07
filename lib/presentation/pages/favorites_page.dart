import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_booking/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:hotel_booking/presentation/widgets/hotel_card.dart';

@RoutePage()
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (final context, final state) {
          if (state is FavoriteInitial) {
            context.read<FavoriteBloc>().add(LoadFavoriteHotels());
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            if (state.hotels.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorites yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add some hotels to your favorites',
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
                  onFavoritePressed: () => context
                      .read<FavoriteBloc>()
                      .add(RemoveFavoriteHotel(hotel: hotel)),
                );
              },
            );
          } else if (state is FavoriteError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
