import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/navigation_viewmodel.dart';
import '../viewmodels/wishlist_viewmodel.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final cartCount = ref.watch(cartViewModelProvider).cartCount;
    final favoriteCount = ref.watch(wishlistViewModelProvider).length;

    void onTabSelected(int index) {
      ref.read(navigationIndexProvider.notifier).state = index;
    }

    final screens = [
      HomeScreen(
        onNavigateToExplore: () => onTabSelected(1),
        onNavigateToWishlist: () => onTabSelected(3),
      ),
      const ExploreScreen(),
      CartScreen(
        onBrowseProducts: () => onTabSelected(1),
      ),
      WishlistScreen(
        onBrowseProducts: () => onTabSelected(1),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
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
          currentIndex: currentIndex,
          onTap: onTabSelected,
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
                isLabelVisible: favoriteCount > 0,
                label: Text(
                  '$favoriteCount',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                backgroundColor: AppTheme.accent,
                child: const Icon(Icons.favorite_outline_rounded),
              ),
              activeIcon: Badge(
                isLabelVisible: favoriteCount > 0,
                label: Text(
                  '$favoriteCount',
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
