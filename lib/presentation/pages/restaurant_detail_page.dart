import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/common/theme.dart';
import 'package:restaurant_flutter/data/datasources/database_helper.dart';
import 'package:restaurant_flutter/data/datasources/restaurant_remote_datasource.dart';
import 'package:restaurant_flutter/data/repositories/favorite_repository_impl.dart';
import 'package:restaurant_flutter/data/repositories/restaurant_repository_impl.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/entities/restaurant_detail.dart';
import 'package:restaurant_flutter/domain/usecases/favorite_usecases.dart';
import 'package:restaurant_flutter/domain/usecases/get_restaurant_detail.dart';
import 'package:restaurant_flutter/presentation/providers/favorite_provider.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_detail_provider.dart';
import 'package:restaurant_flutter/presentation/widgets/error_widget.dart';
import 'package:restaurant_flutter/presentation/widgets/loading_shimmer.dart';

class RestaurantDetailPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();
    final favoriteRepo = FavoriteRepositoryImpl(databaseHelper: dbHelper);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(
            getRestaurantDetail: GetRestaurantDetail(
              RestaurantRepositoryImpl(
                remoteDataSource: RestaurantRemoteDataSource(),
              ),
            ),
          )..fetchRestaurantDetail(restaurantId),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(
            getFavorites: GetFavorites(favoriteRepo),
            addFavorite: AddFavorite(favoriteRepo),
            removeFavorite: RemoveFavorite(favoriteRepo),
            checkIsFavorite: CheckIsFavorite(favoriteRepo),
          )..checkFavoriteStatus(restaurantId),
        ),
      ],
      child: _RestaurantDetailView(restaurantId: restaurantId),
    );
  }
}

class _RestaurantDetailView extends StatelessWidget {
  final String restaurantId;

  const _RestaurantDetailView({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          return switch (provider.state) {
            ResultLoading() => const _DetailLoadingView(),
            ResultLoaded<RestaurantDetail>(data: final detail) =>
              _DetailContentView(detail: detail),
            ResultError(message: final message) => Scaffold(
                appBar: AppBar(),
                body: AppErrorWidget(
                  message: message,
                  onRetry: () {
                    provider.fetchRestaurantDetail(restaurantId);
                  },
                ),
              ),
          };
        },
      ),
    );
  }
}

class _DetailLoadingView extends StatelessWidget {
  const _DetailLoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading...')),
      body: const RestaurantDetailShimmer(),
    );
  }
}

class _DetailContentView extends StatelessWidget {
  final RestaurantDetail detail;

  const _DetailContentView({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: Consumer<FavoriteProvider>(
        builder: (context, favProvider, child) {
          return FloatingActionButton(
            onPressed: () {
              final restaurant = Restaurant(
                id: detail.id,
                name: detail.name,
                description: detail.description,
                pictureId: detail.pictureId,
                city: detail.city,
                rating: detail.rating,
              );
              favProvider.toggleFavorite(restaurant);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    favProvider.isFavorite
                        ? 'Removed from favorites'
                        : 'Added to favorites',
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            backgroundColor: theme.colorScheme.primary,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                favProvider.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                key: ValueKey(favProvider.isFavorite),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
      body: CustomScrollView(
      slivers: [
        // Hero Image AppBar
        SliverAppBar(
          expandedHeight: screenWidth > 600 ? 350 : 280,
          pinned: true,
          stretch: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: theme.scaffoldBackgroundColor.withValues(
                alpha: 0.8,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'restaurant-image-${detail.id}',
              child: CachedNetworkImage(
                imageUrl: detail.largeImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 48,
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 600 ? 40 : 20,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Rating
                _buildHeader(theme),
                const SizedBox(height: 16),

                // Location & Address
                _buildLocationInfo(theme),
                const SizedBox(height: 20),

                // Categories
                if (detail.categories.isNotEmpty) ...[
                  _buildCategories(theme),
                  const SizedBox(height: 24),
                ],

                // Description
                _buildSection(
                  theme: theme,
                  title: 'Description',
                  icon: Icons.info_outline_rounded,
                  child: Text(
                    detail.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Menu - Foods
                _buildSection(
                  theme: theme,
                  title: 'Foods',
                  icon: Icons.restaurant_menu_rounded,
                  child: _buildMenuGrid(
                    theme,
                    detail.menus.foods,
                    Icons.lunch_dining_rounded,
                  ),
                ),
                const SizedBox(height: 24),

                // Menu - Drinks
                _buildSection(
                  theme: theme,
                  title: 'Drinks',
                  icon: Icons.local_cafe_rounded,
                  child: _buildMenuGrid(
                    theme,
                    detail.menus.drinks,
                    Icons.local_cafe_rounded,
                  ),
                ),
                const SizedBox(height: 24),

                // Customer Reviews
                if (detail.customerReviews.isNotEmpty) ...[
                  _buildSection(
                    theme: theme,
                    title: 'Reviews',
                    icon: Icons.rate_review_rounded,
                    child: _buildReviews(theme),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(detail.name, style: theme.textTheme.headlineMedium),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.starColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: 20, color: AppTheme.starColor),
              const SizedBox(width: 4),
              Text(
                detail.rating.toString(),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.starColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.location_city_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  detail.city,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.pin_drop_rounded,
                size: 18,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  detail.address,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: detail.categories.map((category) {
        return Chip(
          label: Text(category.name),
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: theme.textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildMenuGrid(ThemeData theme, List<MenuItem> items, IconData icon) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  item.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviews(ThemeData theme) {
    return Column(
      children: detail.customerReviews.take(5).map((review) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    child: Text(
                      review.name.isNotEmpty
                          ? review.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(review.date, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                review.review,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
