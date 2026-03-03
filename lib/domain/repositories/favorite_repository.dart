import 'package:restaurant_flutter/domain/entities/restaurant.dart';

abstract class FavoriteRepository {
  Future<List<Restaurant>> getFavorites();
  Future<bool> isFavorite(String id);
  Future<void> addFavorite(Restaurant restaurant);
  Future<void> removeFavorite(String id);
}
