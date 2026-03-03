import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/presentation/pages/restaurant_detail_page.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_list_provider.dart';
import 'package:restaurant_flutter/presentation/providers/theme_provider.dart';
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
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Restaurant',
                          style: theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Recommendation restaurant for you!',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  _buildThemeToggle(context),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Content
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

  Widget _buildThemeToggle(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => themeProvider.toggleTheme(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween(begin: 0.75, end: 1.0).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Icon(
            themeProvider.isDarkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            key: ValueKey(themeProvider.isDarkMode),
            color: theme.colorScheme.primary,
            size: 22,
          ),
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
