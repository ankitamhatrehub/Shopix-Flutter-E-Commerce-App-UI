import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

enum SortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  topRated,
}

class CatalogState {
  final String selectedCategoryId;
  final String searchQuery;
  final SortOption sortOption;

  const CatalogState({
    this.selectedCategoryId = 'all',
    this.searchQuery = '',
    this.sortOption = SortOption.featured,
  });

  CatalogState copyWith({
    String? selectedCategoryId,
    String? searchQuery,
    SortOption? sortOption,
  }) {
    return CatalogState(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class CatalogViewModel extends StateNotifier<CatalogState> {
  CatalogViewModel() : super(const CatalogState());

  void selectCategory(String categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void resetFilters() {
    state = const CatalogState();
  }
}

final catalogViewModelProvider =
    StateNotifierProvider<CatalogViewModel, CatalogState>((ref) {
  return CatalogViewModel();
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  final catalogState = ref.watch(catalogViewModelProvider);

  final allProducts = repo.getProducts();

  // Filter
  final filtered = allProducts.where((product) {
    final matchesCategory = catalogState.selectedCategoryId == 'all' ||
        product.category.toLowerCase() ==
            catalogState.selectedCategoryId.toLowerCase();
    final matchesSearch = catalogState.searchQuery.isEmpty ||
        product.title
            .toLowerCase()
            .contains(catalogState.searchQuery.toLowerCase()) ||
        product.category
            .toLowerCase()
            .contains(catalogState.searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  }).toList();

  // Sort
  switch (catalogState.sortOption) {
    case SortOption.featured:
      return filtered;
    case SortOption.priceLowToHigh:
      filtered.sort((a, b) => a.price.compareTo(b.price));
      return filtered;
    case SortOption.priceHighToLow:
      filtered.sort((a, b) => b.price.compareTo(a.price));
      return filtered;
    case SortOption.topRated:
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
      return filtered;
  }
});

