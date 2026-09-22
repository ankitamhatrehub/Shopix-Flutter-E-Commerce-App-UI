import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class ShopState extends ChangeNotifier {
  final List<Product> _products = List.from(Product.sampleProducts);
  final List<CartItem> _cartItems = [];
  final Set<String> _favoriteIds = {'prod_1', 'prod_2'};
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String? _appliedPromoCode;
  double _discountPercent = 0.0;

  // Getters
  List<Product> get products => List.unmodifiable(_products);
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  String? get appliedPromoCode => _appliedPromoCode;
  double get discountPercent => _discountPercent;

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shippingFee => subtotal > 150.0 || subtotal == 0 ? 0.0 : 9.99;

  double get discountAmount => subtotal * _discountPercent;

  double get total => (subtotal - discountAmount) + shippingFee;

  List<Product> get favoriteProducts =>
      _products.where((p) => _favoriteIds.contains(p.id)).toList();

  List<Product> get featuredProducts =>
      _products.where((p) => p.isFeatured).toList();

  List<Product> get flashSaleProducts =>
      _products.where((p) => p.isFlashSale).toList();

  List<Product> get filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategoryId == 'all' ||
          product.category.toLowerCase() == _selectedCategoryId.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Actions
  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addToCart(
    Product product, {
    Color? color,
    String? size,
    int quantity = 1,
  }) {
    // Check if matching item already exists
    final index = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor == color &&
          item.selectedSize == size,
    );

    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedColor: color ?? (product.colors.isNotEmpty ? product.colors.first : null),
          selectedSize: size ?? (product.sizes.isNotEmpty ? product.sizes.first : null),
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _appliedPromoCode = null;
    _discountPercent = 0.0;
    notifyListeners();
  }

  bool applyPromo(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'SHOPPIX20') {
      _appliedPromoCode = cleanCode;
      _discountPercent = 0.20; // 20% off
      notifyListeners();
      return true;
    } else if (cleanCode == 'SAVE10') {
      _appliedPromoCode = cleanCode;
      _discountPercent = 0.10; // 10% off
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _appliedPromoCode = null;
    _discountPercent = 0.0;
    notifyListeners();
  }
}

class ShopStateScope extends InheritedNotifier<ShopState> {
  const ShopStateScope({
    super.key,
    required ShopState shopState,
    required super.child,
  }) : super(notifier: shopState);

  static ShopState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ShopStateScope>();
    assert(scope != null, 'No ShopStateScope found in context');
    return scope!.notifier!;
  }
}
