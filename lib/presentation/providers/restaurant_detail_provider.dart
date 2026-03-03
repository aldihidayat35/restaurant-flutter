import 'package:flutter/material.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant_detail.dart';
import 'package:restaurant_flutter/domain/usecases/get_restaurant_detail.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final GetRestaurantDetail getRestaurantDetail;

  RestaurantDetailProvider({required this.getRestaurantDetail});

  ResultState<RestaurantDetail> _state = const ResultLoading();
  ResultState<RestaurantDetail> get state => _state;

  Future<void> fetchRestaurantDetail(String id) async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      final detail = await getRestaurantDetail.execute(id);
      _state = ResultLoaded(detail);
    } catch (e) {
      _state = ResultError(e.toString());
    }

    notifyListeners();
  }
}
