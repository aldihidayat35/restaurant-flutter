import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Test', () {
    testWidgets('app should launch and show restaurant list page',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Restaurant'), findsOneWidget);
      expect(find.text('Recommendation restaurant for you!'), findsOneWidget);

      expect(
        find.byType(NavigationBar),
        findsOneWidget,
      );
    });
  });
}
