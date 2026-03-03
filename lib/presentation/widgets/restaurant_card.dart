import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_flutter/common/theme.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            Hero(
              tag: 'restaurant-image-${restaurant.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: restaurant.smallImageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 120,
                    height: 120,
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      size: 32,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 120,
                    height: 120,
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            restaurant.city,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.starColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppTheme.starColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.rating.toString(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppTheme.starColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
