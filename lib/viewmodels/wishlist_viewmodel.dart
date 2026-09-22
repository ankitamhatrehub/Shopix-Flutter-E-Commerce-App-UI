import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class WishlistViewModel extends StateNotifier<Set<String>> {
  WishlistViewModel() : super({'prod_1', 'prod_2'});

  bool isFavorite(String productId) => state.contains(productId);

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = Set.from(state)..remove(productId);
    } else {
      state = Set.from(state)..add(productId);
    }
  }
}

final wishlistViewModelProvider =
    StateNotifierProvider<WishlistViewModel, Set<String>>((ref) {
  return WishlistViewModel();
});

final favoriteProductsProvider = Provider<List<Product>>((ref) {
  final favoriteIds = ref.watch(wishlistViewModelProvider);
  final repo = ref.watch(productRepositoryProvider);
  final allProducts = repo.getProducts();
  return allProducts.where((p) => favoriteIds.contains(p.id)).toList();
});

