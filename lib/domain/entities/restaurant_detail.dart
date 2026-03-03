class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final double rating;
  final List<Category> categories;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  const RestaurantDetail({
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

  String get smallImageUrl =>
      'https://restaurant-api.dicoding.dev/images/small/$pictureId';

  String get mediumImageUrl =>
      'https://restaurant-api.dicoding.dev/images/medium/$pictureId';

  String get largeImageUrl =>
      'https://restaurant-api.dicoding.dev/images/large/$pictureId';
}

class Category {
  final String name;

  const Category({required this.name});
}

class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  const Menus({required this.foods, required this.drinks});
}

class MenuItem {
  final String name;

  const MenuItem({required this.name});
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  const CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });
}
