import 'package:restaurant_flutter/domain/entities/restaurant_detail.dart';
import 'package:restaurant_flutter/domain/repositories/restaurant_repository.dart';

class GetRestaurantDetail {
  final RestaurantRepository repository;

  GetRestaurantDetail(this.repository);

  Future<RestaurantDetail> execute(String id) async {
    return await repository.getRestaurantDetail(id);
  }
}
