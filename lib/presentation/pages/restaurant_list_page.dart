import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/presentation/pages/restaurant_detail_page.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_list_provider.dart';
import 'package:restaurant_flutter/presentation/widgets/error_widget.dart';
import 'package:restaurant_flutter/presentation/widgets/loading_shimmer.dart';
import 'package:restaurant_flutter/presentation/widgets/restaurant_card.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

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
                  Text('Restaurant', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Recommendation restaurant for you!',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<RestaurantListProvider>(
                builder: (context, provider, child) {
                  return switch (provider.state) {
                    ResultLoading() => const RestaurantListShimmer(),
                    ResultLoaded<List<Restaurant>>(data: final restaurants) =>
                      _buildRestaurantList(context, restaurants, provider),
                    ResultError(message: final message) => AppErrorWidget(
                        message: message,
                        onRetry: () => provider.fetchRestaurantList(),
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

  Widget _buildRestaurantList(
    BuildContext context,
    List<Restaurant> restaurants,
    RestaurantListProvider provider,
  ) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchRestaurantList(),
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return RestaurantCard(
            restaurant: restaurant,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetailPage(restaurantId: restaurant.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
