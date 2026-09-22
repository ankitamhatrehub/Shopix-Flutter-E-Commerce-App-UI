import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';
import '../viewmodels/catalog_viewmodel.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(catalogViewModelProvider).searchQuery;
    if (initialQuery.isNotEmpty) {
      _searchController.text = initialQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogViewModelProvider);
    final sortedProducts = ref.watch(filteredProductsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Explore Catalog'),
      ),
      body: Column(
        children: [
          // Search Box & Sort Action
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      ref.read(catalogViewModelProvider.notifier).setSearchQuery(val);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search shoes, tech, fashion...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(catalogViewModelProvider.notifier).setSearchQuery('');
                              },
                            )
                          : null,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<SortOption>(
                  tooltip: 'Sort by',
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.background,
                    ),
                    child: const Icon(Icons.sort_rounded, size: 20, color: AppTheme.textPrimary),
                  ),
                  onSelected: (sort) {
                    ref.read(catalogViewModelProvider.notifier).setSortOption(sort);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: SortOption.featured,
                      child: Text('Featured'),
                    ),
                    const PopupMenuItem(
                      value: SortOption.priceLowToHigh,
                      child: Text('Price: Low to High'),
                    ),
                    const PopupMenuItem(
                      value: SortOption.priceHighToLow,
                      child: Text('Price: High to Low'),
                    ),
                    const PopupMenuItem(
                      value: SortOption.topRated,
                      child: Text('Top Rated'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Categories horizontal list
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: Category.sampleCategories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = Category.sampleCategories[index];
                  return CategoryChip(
                    category: cat,
                    isSelected: catalogState.selectedCategoryId == cat.id,
                    onTap: () {
                      ref.read(catalogViewModelProvider.notifier).selectCategory(cat.id);
                    },
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1, color: AppTheme.border),

          // Results header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sortedProducts.length} ${sortedProducts.length == 1 ? "Product" : "Products"} found',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  _getSortLabel(catalogState.sortOption),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Product Grid or Empty State
          Expanded(
            child: sortedProducts.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Products Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try changing your search terms or filter criteria.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () {
                              _searchController.clear();
                              ref.read(catalogViewModelProvider.notifier).resetFilters();
                            },
                            child: const Text('Reset Filters'),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: sortedProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.60,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: sortedProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.featured:
        return 'Sorted: Featured';
      case SortOption.priceLowToHigh:
        return 'Sorted: Price ↑';
      case SortOption.priceHighToLow:
        return 'Sorted: Price ↓';
      case SortOption.topRated:
        return 'Sorted: Top Rated';
    }
  }
}
