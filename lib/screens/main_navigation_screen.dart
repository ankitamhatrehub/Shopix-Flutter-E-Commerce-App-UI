import 'package:flutter/material.dart';
import '../state/shop_state.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ShopStateScope.of(context);
    final cartCount = state.cartCount;

    final screens = [
      HomeScreen(
        onNavigateToExplore: () => _onTabSelected(1),
        onNavigateToWishlist: () => _onTabSelected(3),
      ),
      const ExploreScreen(),
      CartScreen(
        onBrowseProducts: () => _onTabSelected(1),
      ),
      WishlistScreen(
        onBrowseProducts: () => _onTabSelected(1),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppTheme.border.withOpacity(0.8), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              activeIcon: Icon(Icons.manage_search_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  '$cartCount',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                backgroundColor: AppTheme.primary,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  '$cartCount',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                backgroundColor: AppTheme.primary,
                child: const Icon(Icons.shopping_bag_rounded),
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: state.favoriteIds.isNotEmpty,
                label: Text(
                  '${state.favoriteIds.length}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                backgroundColor: AppTheme.accent,
                child: const Icon(Icons.favorite_outline_rounded),
              ),
              activeIcon: Badge(
                isLabelVisible: state.favoriteIds.isNotEmpty,
                label: Text(
                  '${state.favoriteIds.length}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                backgroundColor: AppTheme.accent,
                child: const Icon(Icons.favorite_rounded),
              ),
              label: 'Wishlist',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
