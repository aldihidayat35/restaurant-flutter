import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/repositories/restaurant_repository.dart';

class GetRestaurantList {
  final RestaurantRepository repository;

  GetRestaurantList(this.repository);

  Future<List<Restaurant>> execute() async {
    return await repository.getRestaurantList();
  }
}
