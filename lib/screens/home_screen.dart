import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../repositories/product_repository.dart';
import '../theme/app_theme.dart';
import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../viewmodels/wishlist_viewmodel.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import 'notifications_screen.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onNavigateToExplore;
  final VoidCallback onNavigateToWishlist;

  const HomeScreen({
    super.key,
    required this.onNavigateToExplore,
    required this.onNavigateToWishlist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(productRepositoryProvider);
    final flashSaleProducts = repo.getFlashSaleProducts();
    final popularProducts = repo.getProducts();
    final favoriteIds = ref.watch(wishlistViewModelProvider);
    final selectedCategoryId =
        ref.watch(catalogViewModelProvider).selectedCategoryId;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deliver to',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
                const SizedBox(width: 4),
                const Text(
                  'Home, 742 Evergreen Terr.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.textSecondary),
              ],
            ),
          ],
        ),
        actions: [
          // Wishlist Action
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border_rounded),
                onPressed: onNavigateToWishlist,
              ),
              if (favoriteIds.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${favoriteIds.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              if (ref.watch(unreadNotificationsCountProvider) > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${ref.watch(unreadNotificationsCountProvider)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: InkWell(
                  onTap: onNavigateToExplore,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, color: AppTheme.textSecondary, size: 22),
                        SizedBox(width: 12),
                        Text(
                          'Search anything on Shoppix...',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.tune_rounded, color: AppTheme.primary, size: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Promotional Banner
              PromoBanner(onShopNow: onNavigateToExplore),
              const SizedBox(height: 20),

              // Categories Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextButton(
                      onPressed: onNavigateToExplore,
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Categories Horizontal List
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: Category.sampleCategories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final cat = Category.sampleCategories[index];
                    return CategoryChip(
                      category: cat,
                      isSelected: selectedCategoryId == cat.id,
                      onTap: () {
                        ref
                            .read(catalogViewModelProvider.notifier)
                            .selectCategory(cat.id);
                        onNavigateToExplore();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Flash Sale Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Text(
                      'Flash Sale',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.bolt_rounded, color: AppTheme.accent, size: 22),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: AppTheme.accent),
                          SizedBox(width: 4),
                          Text(
                            '04 : 22 : 55',
                            style: TextStyle(
                              color: AppTheme.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Horizontal Flash Sale List
              SizedBox(
                height: 280,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: flashSaleProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final product = flashSaleProducts[index];
                    return ProductCard(
                      product: product,
                      width: 175,
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // Popular Products Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular on Shoppix',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextButton(
                      onPressed: onNavigateToExplore,
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 2-column Grid of Popular Products
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: popularProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.60,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: popularProducts[index]);
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
