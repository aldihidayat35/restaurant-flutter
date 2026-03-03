import 'package:restaurant_flutter/data/datasources/restaurant_remote_datasource.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/entities/restaurant_detail.dart';
import 'package:restaurant_flutter/domain/repositories/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Restaurant>> getRestaurantList() async {
    final models = await remoteDataSource.getRestaurantList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    final model = await remoteDataSource.getRestaurantDetail(id);
    return model.toEntity();
  }
}
