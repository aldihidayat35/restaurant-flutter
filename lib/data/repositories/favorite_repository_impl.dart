import 'package:restaurant_flutter/data/datasources/database_helper.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final DatabaseHelper databaseHelper;

  FavoriteRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<Restaurant>> getFavorites() async {
    return await databaseHelper.getFavorites();
  }

  @override
  Future<bool> isFavorite(String id) async {
    return await databaseHelper.isFavorite(id);
  }

  @override
  Future<void> addFavorite(Restaurant restaurant) async {
    await databaseHelper.insertFavorite(restaurant);
  }

  @override
  Future<void> removeFavorite(String id) async {
    await databaseHelper.removeFavorite(id);
  }
}
