class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  String get smallImageUrl =>
      'https://restaurant-api.dicoding.dev/images/small/$pictureId';

  String get mediumImageUrl =>
      'https://restaurant-api.dicoding.dev/images/medium/$pictureId';

  String get largeImageUrl =>
      'https://restaurant-api.dicoding.dev/images/large/$pictureId';
}
