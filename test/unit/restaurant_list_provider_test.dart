import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/get_restaurant_list.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_list_provider.dart';

class MockGetRestaurantList extends Mock implements GetRestaurantList {}

void main() {
  late MockGetRestaurantList mockGetRestaurantList;
  late RestaurantListProvider provider;

  final tRestaurantList = [
    const Restaurant(
      id: '1',
      name: 'Test Restaurant',
      description: 'A test restaurant',
      pictureId: '14',
      city: 'Medan',
      rating: 4.5,
    ),
    const Restaurant(
      id: '2',
      name: 'Second Restaurant',
      description: 'Another test',
      pictureId: '25',
      city: 'Jakarta',
      rating: 4.0,
    ),
  ];

  setUp(() {
    mockGetRestaurantList = MockGetRestaurantList();
  });

  group('RestaurantListProvider', () {
    test('initial state should be ResultLoading', () {
      when(() => mockGetRestaurantList.execute())
          .thenAnswer((_) async => tRestaurantList);

      provider = RestaurantListProvider(
        getRestaurantList: mockGetRestaurantList,
      );

      expect(provider.state, isA<ResultLoading>());
    });

    test('should return list of restaurants when API call is successful',
        () async {
      when(() => mockGetRestaurantList.execute())
          .thenAnswer((_) async => tRestaurantList);

      provider = RestaurantListProvider(
        getRestaurantList: mockGetRestaurantList,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      expect(provider.state, isA<ResultLoaded<List<Restaurant>>>());
      final state = provider.state as ResultLoaded<List<Restaurant>>;
      expect(state.data, tRestaurantList);
      expect(state.data.length, 2);
    });

    test('should return error when API call fails', () async {
      when(() => mockGetRestaurantList.execute())
          .thenThrow(Exception('Failed to load restaurant list'));

      provider = RestaurantListProvider(
        getRestaurantList: mockGetRestaurantList,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      expect(provider.state, isA<ResultError>());
      final state = provider.state as ResultError;
      expect(state.message, contains('Failed to load restaurant list'));
    });
  });
}
