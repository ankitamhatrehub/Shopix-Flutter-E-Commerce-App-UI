import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart';
import 'state/shop_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShoppixApp());
}

class ShoppixApp extends StatefulWidget {
  const ShoppixApp({super.key});

  @override
  State<ShoppixApp> createState() => _ShoppixAppState();
}

class _ShoppixAppState extends State<ShoppixApp> {
  final ShopState _shopState = ShopState();

  @override
  void dispose() {
    _shopState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShopStateScope(
      shopState: _shopState,
      child: MaterialApp(
        title: 'Shoppix',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
