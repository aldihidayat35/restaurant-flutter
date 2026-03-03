import 'package:restaurant_flutter/domain/entities/restaurant_detail.dart';

class RestaurantDetailModel {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final double rating;
  final List<CategoryModel> categories;
  final MenusModel menus;
  final List<CustomerReviewModel> customerReviews;

  const RestaurantDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
      menus: MenusModel.fromJson(json['menus'] ?? {}),
      customerReviews:
          (json['customerReviews'] as List<dynamic>?)
              ?.map((e) => CustomerReviewModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  RestaurantDetail toEntity() {
    return RestaurantDetail(
      id: id,
      name: name,
      description: description,
      pictureId: pictureId,
      city: city,
      address: address,
      rating: rating,
      categories: categories.map((e) => e.toEntity()).toList(),
      menus: menus.toEntity(),
      customerReviews: customerReviews.map((e) => e.toEntity()).toList(),
    );
  }
}

class CategoryModel {
  final String name;

  const CategoryModel({required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(name: json['name'] ?? '');
  }

  Category toEntity() => Category(name: name);
}

class MenusModel {
  final List<MenuItemModel> foods;
  final List<MenuItemModel> drinks;

  const MenusModel({required this.foods, required this.drinks});

  factory MenusModel.fromJson(Map<String, dynamic> json) {
    return MenusModel(
      foods:
          (json['foods'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e))
              .toList() ??
          [],
      drinks:
          (json['drinks'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Menus toEntity() {
    return Menus(
      foods: foods.map((e) => e.toEntity()).toList(),
      drinks: drinks.map((e) => e.toEntity()).toList(),
    );
  }
}

class MenuItemModel {
  final String name;

  const MenuItemModel({required this.name});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(name: json['name'] ?? '');
  }

  MenuItem toEntity() => MenuItem(name: name);
}

class CustomerReviewModel {
  final String name;
  final String review;
  final String date;

  const CustomerReviewModel({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReviewModel.fromJson(Map<String, dynamic> json) {
    return CustomerReviewModel(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }

  CustomerReview toEntity() {
    return CustomerReview(name: name, review: review, date: date);
  }
}
