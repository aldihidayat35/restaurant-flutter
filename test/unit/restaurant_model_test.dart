import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/data/models/restaurant_model.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';

void main() {
  group('RestaurantModel', () {
    test('should correctly parse from JSON', () {
      final json = {
        'id': 'rqdv5juczeskfw1e867',
        'name': 'Melting Pot',
        'description': 'Lorem ipsum dolor sit amet',
        'pictureId': '14',
        'city': 'Medan',
        'rating': 4.2,
      };

      final model = RestaurantModel.fromJson(json);

      expect(model.id, 'rqdv5juczeskfw1e867');
      expect(model.name, 'Melting Pot');
      expect(model.city, 'Medan');
      expect(model.rating, 4.2);
    });

    test('should correctly convert to entity', () {
      const model = RestaurantModel(
        id: '1',
        name: 'Test',
        description: 'Desc',
        pictureId: '14',
        city: 'Jakarta',
        rating: 4.5,
      );

      final entity = model.toEntity();

      expect(entity, isA<Restaurant>());
      expect(entity.id, '1');
      expect(entity.name, 'Test');
      expect(entity.city, 'Jakarta');
      expect(entity.rating, 4.5);
    });
  });
}
