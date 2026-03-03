import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/entities/restaurant_detail.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurantList();
  Future<RestaurantDetail> getRestaurantDetail(String id);
}
