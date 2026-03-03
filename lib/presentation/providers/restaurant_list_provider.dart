import 'package:flutter/material.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/get_restaurant_list.dart';

class RestaurantListProvider extends ChangeNotifier {
  final GetRestaurantList getRestaurantList;

  RestaurantListProvider({required this.getRestaurantList}) {
    fetchRestaurantList();
  }

  ResultState<List<Restaurant>> _state = const ResultLoading();
  ResultState<List<Restaurant>> get state => _state;

  Future<void> fetchRestaurantList() async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      final restaurants = await getRestaurantList.execute();
      _state = ResultLoaded(restaurants);
    } catch (e) {
      _state = ResultError(e.toString());
    }

    notifyListeners();
  }
}
