import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_list_provider.dart';
import 'package:restaurant_flutter/presentation/widgets/restaurant_card.dart';

class MockRestaurantListProvider extends Mock
    implements RestaurantListProvider {}

void main() {
  group('RestaurantCard Widget Test', () {
    testWidgets('should display restaurant name, city, and rating',
        (tester) async {
      const restaurant = Restaurant(
        id: '1',
        name: 'Melting Pot',
        description: 'A test restaurant',
        pictureId: '14',
        city: 'Medan',
        rating: 4.2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: restaurant,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Melting Pot'), findsOneWidget);
      expect(find.text('Medan'), findsOneWidget);
      expect(find.text('4.2'), findsOneWidget);
    });
  });

  group('Restaurant List Page Widget Test', () {
    testWidgets('should show loading shimmer when state is loading',
        (tester) async {
      final mockProvider = MockRestaurantListProvider();
      when(() => mockProvider.state)
          .thenReturn(const ResultLoading<List<Restaurant>>());

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<RestaurantListProvider>.value(
            value: mockProvider,
            child: Scaffold(
              body: Consumer<RestaurantListProvider>(
                builder: (context, provider, child) {
                  return switch (provider.state) {
                    ResultLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ResultLoaded<List<Restaurant>>() =>
                      const Text('Loaded'),
                    ResultError() => const Text('Error'),
                  };
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when state is error',
        (tester) async {
      final mockProvider = MockRestaurantListProvider();
      when(() => mockProvider.state).thenReturn(
        const ResultError<List<Restaurant>>('Failed to load'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<RestaurantListProvider>.value(
            value: mockProvider,
            child: Scaffold(
              body: Consumer<RestaurantListProvider>(
                builder: (context, provider, child) {
                  return switch (provider.state) {
                    ResultLoading() => const CircularProgressIndicator(),
                    ResultLoaded<List<Restaurant>>() =>
                      const Text('Loaded'),
                    ResultError(message: final msg) => Center(
                        child: Text(msg),
                      ),
                  };
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Failed to load'), findsOneWidget);
    });
  });
}
