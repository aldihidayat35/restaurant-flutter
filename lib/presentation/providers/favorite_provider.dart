import 'package:flutter/material.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/favorite_usecases.dart';

class FavoriteProvider extends ChangeNotifier {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final CheckIsFavorite checkIsFavorite;

  FavoriteProvider({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
    required this.checkIsFavorite,
  });

  ResultState<List<Restaurant>> _state = const ResultLoading();
  ResultState<List<Restaurant>> get state => _state;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  Future<void> fetchFavorites() async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      final favorites = await getFavorites.execute();
      if (favorites.isEmpty) {
        _state = const ResultLoaded([]);
      } else {
        _state = ResultLoaded(favorites);
      }
    } catch (e) {
      _state = ResultError(e.toString());
    }

    notifyListeners();
  }

  Future<void> checkFavoriteStatus(String id) async {
    _isFavorite = await checkIsFavorite.execute(id);
    notifyListeners();
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (_isFavorite) {
      await removeFavorite.execute(restaurant.id);
      _isFavorite = false;
    } else {
      await addFavorite.execute(restaurant);
      _isFavorite = true;
    }
    notifyListeners();
  }
}
