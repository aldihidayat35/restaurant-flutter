import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/repositories/favorite_repository.dart';

class GetFavorites {
  final FavoriteRepository repository;
  GetFavorites(this.repository);

  Future<List<Restaurant>> execute() async {
    return await repository.getFavorites();
  }
}

class CheckIsFavorite {
  final FavoriteRepository repository;
  CheckIsFavorite(this.repository);

  Future<bool> execute(String id) async {
    return await repository.isFavorite(id);
  }
}

class AddFavorite {
  final FavoriteRepository repository;
  AddFavorite(this.repository);

  Future<void> execute(Restaurant restaurant) async {
    return await repository.addFavorite(restaurant);
  }
}

class RemoveFavorite {
  final FavoriteRepository repository;
  RemoveFavorite(this.repository);

  Future<void> execute(String id) async {
    return await repository.removeFavorite(id);
  }
}
