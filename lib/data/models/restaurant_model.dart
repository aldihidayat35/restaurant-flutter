import 'package:restaurant_flutter/domain/entities/restaurant.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  Restaurant toEntity() {
    return Restaurant(
      id: id,
      name: name,
      description: description,
      pictureId: pictureId,
      city: city,
      rating: rating,
    );
  }
}
