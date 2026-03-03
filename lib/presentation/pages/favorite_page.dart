import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/presentation/pages/restaurant_detail_page.dart';
import 'package:restaurant_flutter/presentation/providers/favorite_provider.dart';
import 'package:restaurant_flutter/presentation/widgets/restaurant_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoriteProvider>().fetchFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Favorites', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Your saved restaurants',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<FavoriteProvider>(
                builder: (context, provider, child) {
                  return switch (provider.state) {
                    ResultLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ResultLoaded<List<Restaurant>>(data: final favorites) =>
                      favorites.isEmpty
                          ? _buildEmptyState(theme)
                          : _buildFavoriteList(context, favorites),
                    ResultError(message: final message) => Center(
                        child: Text(
                          message,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 56,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text('No favorites yet', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Start adding restaurants to\nyour favorites list!',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteList(
    BuildContext context,
    List<Restaurant> favorites,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<FavoriteProvider>().fetchFavorites(),
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final restaurant = favorites[index];
          return RestaurantCard(
            restaurant: restaurant,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetailPage(restaurantId: restaurant.id),
                ),
              );
              if (context.mounted) {
                context.read<FavoriteProvider>().fetchFavorites();
              }
            },
          );
        },
      ),
    );
  }
}
