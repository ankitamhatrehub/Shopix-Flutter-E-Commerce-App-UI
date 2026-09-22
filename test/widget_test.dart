import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoppix_frontend/main.dart';
import 'package:shoppix_frontend/screens/main_navigation_screen.dart';
import 'package:shoppix_frontend/theme/app_theme.dart';

void main() {
  testWidgets('ShoppixApp launches into 3D Splash and transitions to Onboarding',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ShoppixApp(),
      ),
    );

    // Initial frame renders 3D Splash brand title
    expect(find.text('SHOPPIX'), findsOneWidget);
    expect(find.text('NEXT-GEN 3D SHOPPING'), findsOneWidget);

    // Advance time past the 2300ms splash animation timer
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pump(const Duration(milliseconds: 800));

    // Onboarding view is now shown with Skip button
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Discover 3D\nTrending Styles'), findsOneWidget);

    // Tapping Skip proceeds to MainNavigationScreen
    await tester.tap(find.text('Skip'));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify main screen elements
    expect(find.text('Deliver to'), findsOneWidget);
  });

  testWidgets('MainNavigationScreen renders navigation tabs and switches tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MainNavigationScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Verify bottom navigation tabs exist
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
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Explore Catalog'), findsOneWidget);

    // Switch to Cart tab
    await tester.tap(find.text('Cart'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('My Cart'), findsOneWidget);

    // Switch to Wishlist tab
    await tester.tap(find.text('Wishlist'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('My Wishlist'), findsOneWidget);

    // Switch to Account tab
    await tester.tap(find.text('Account'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('My Account'), findsOneWidget);
  });
}
