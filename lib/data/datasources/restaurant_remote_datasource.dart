import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_flutter/data/models/restaurant_model.dart';
import 'package:restaurant_flutter/data/models/restaurant_detail_model.dart';

class RestaurantRemoteDataSource {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  final http.Client client;

  RestaurantRemoteDataSource({http.Client? client})
    : client = client ?? http.Client();

  Future<List<RestaurantModel>> getRestaurantList() async {
    final response = await client.get(Uri.parse('$_baseUrl/list'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> restaurantsJson = body['restaurants'];
      return restaurantsJson
          .map((json) => RestaurantModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailModel> getRestaurantDetail(String id) async {
    final response = await client.get(Uri.parse('$_baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return RestaurantDetailModel.fromJson(body['restaurant']);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
}
