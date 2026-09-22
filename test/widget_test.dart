import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoppix_frontend/main.dart';

void main() {
  testWidgets('Shoppix App renders home screen and navigation tabs',
      (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: ShoppixApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify navigation tabs exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);

    // Verify home screen elements
    expect(find.text('Deliver to'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Flash Sale'), findsOneWidget);
    expect(find.text('Popular on Shoppix'), findsOneWidget);

    // Switch to Explore tab
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    expect(find.text('Explore Catalog'), findsOneWidget);

    // Switch to Cart tab
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('My Cart'), findsOneWidget);

    // Switch to Account tab
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();

    expect(find.text('My Account'), findsOneWidget);
    expect(find.text('Ankita Shelke'), findsOneWidget);
  });
}
