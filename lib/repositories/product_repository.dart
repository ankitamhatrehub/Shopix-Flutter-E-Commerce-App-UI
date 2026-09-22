import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../models/product.dart';

abstract class ProductRepository {
  List<Product> getProducts();
  List<Category> getCategories();
  List<Product> getFeaturedProducts();
  List<Product> getFlashSaleProducts();
  Product? getProductById(String id);
}

class LocalProductRepository implements ProductRepository {
  const LocalProductRepository();

  @override
  List<Product> getProducts() => List.unmodifiable(Product.sampleProducts);

  @override
  List<Category> getCategories() => List.unmodifiable(Category.sampleCategories);

  @override
  List<Product> getFeaturedProducts() =>
      Product.sampleProducts.where((p) => p.isFeatured).toList();

  @override
  List<Product> getFlashSaleProducts() =>
      Product.sampleProducts.where((p) => p.isFlashSale).toList();

  @override
  Product? getProductById(String id) {
    try {
      return Product.sampleProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return const LocalProductRepository();
});

