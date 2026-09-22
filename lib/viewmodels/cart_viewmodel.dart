import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartState {
  final List<CartItem> items;
  final String? appliedPromoCode;
  final double discountPercent;

  const CartState({
    this.items = const [],
    this.appliedPromoCode,
    this.discountPercent = 0.0,
  });

  int get cartCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shippingFee => subtotal > 150.0 || subtotal == 0 ? 0.0 : 9.99;

  double get discountAmount => subtotal * discountPercent;

  double get total => (subtotal - discountAmount) + shippingFee;

  CartState copyWith({
    List<CartItem>? items,
    String? Function()? appliedPromoCode,
    double? discountPercent,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedPromoCode: appliedPromoCode != null
          ? appliedPromoCode()
          : this.appliedPromoCode,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}

class CartViewModel extends StateNotifier<CartState> {
  CartViewModel() : super(const CartState());

  void addToCart(
    Product product, {
    Color? color,
    String? size,
    int quantity = 1,
  }) {
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor == color &&
          item.selectedSize == size,
    );

    if (index >= 0) {
      currentItems[index].quantity += quantity;
    } else {
      currentItems.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedColor:
              color ?? (product.colors.isNotEmpty ? product.colors.first : null),
          selectedSize:
              size ?? (product.sizes.isNotEmpty ? product.sizes.first : null),
        ),
      );
    }

    state = state.copyWith(items: currentItems);
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < state.items.length) {
      final currentItems = List<CartItem>.from(state.items);
      if (newQuantity <= 0) {
        currentItems.removeAt(index);
      } else {
        currentItems[index].quantity = newQuantity;
      }
      state = state.copyWith(items: currentItems);
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < state.items.length) {
      final currentItems = List<CartItem>.from(state.items);
      currentItems.removeAt(index);
      state = state.copyWith(items: currentItems);
    }
  }

  void clearCart() {
    state = const CartState();
  }

  bool applyPromo(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'SHOPPIX20') {
      state = state.copyWith(
        appliedPromoCode: () => cleanCode,
        discountPercent: 0.20,
      );
      return true;
    } else if (cleanCode == 'SAVE10') {
      state = state.copyWith(
        appliedPromoCode: () => cleanCode,
        discountPercent: 0.10,
      );
      return true;
    }
    return false;
  }

  void removePromo() {
    state = state.copyWith(
      appliedPromoCode: () => null,
      discountPercent: 0.0,
    );
  }
}

final cartViewModelProvider =
    StateNotifierProvider<CartViewModel, CartState>((ref) {
  return CartViewModel();
});

