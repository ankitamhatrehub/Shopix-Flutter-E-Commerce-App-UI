import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/order.dart';
import '../repositories/order_repository.dart';

class OrderState {
  final List<Order> orders;
  final OrderStatus? filterStatus;
  final bool isLoading;

  const OrderState({
    this.orders = const [],
    this.filterStatus,
    this.isLoading = false,
  });

  List<Order> get filteredOrders {
    if (filterStatus == null) return orders;
    return orders.where((o) => o.status == filterStatus).toList();
  }

  OrderState copyWith({
    List<Order>? orders,
    OrderStatus? Function()? filterStatus,
    bool? isLoading,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      filterStatus:
          filterStatus != null ? filterStatus() : this.filterStatus,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class OrderViewModel extends StateNotifier<OrderState> {
  final OrderRepository _orderRepo;

  OrderViewModel(this._orderRepo) : super(const OrderState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true);
    final orders = await _orderRepo.getOrders();
    state = state.copyWith(orders: orders, isLoading: false);
  }

  Future<Order> placeOrder({
    required double totalAmount,
    required int itemCount,
    required String itemsSummary,
    required String addressTitle,
    required String paymentTitle,
  }) async {
    final orderId = 'ord_${DateTime.now().millisecondsSinceEpoch}';
    final orderNumber =
        'SPX-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';

    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateStr = '${months[now.month - 1]} ${now.day}, ${now.year}';

    final newOrder = Order(
      id: orderId,
      orderNumber: orderNumber,
      date: dateStr,
      totalAmount: totalAmount,
      status: OrderStatus.processing,
      itemCount: itemCount,
      itemsSummary: itemsSummary,
      addressTitle: addressTitle,
      paymentTitle: paymentTitle,
    );

    await _orderRepo.createOrder(newOrder);
    state = state.copyWith(orders: [newOrder, ...state.orders]);
    return newOrder;
  }

  void setFilter(OrderStatus? status) {
    state = state.copyWith(filterStatus: () => status);
  }
}

final orderViewModelProvider =
    StateNotifierProvider<OrderViewModel, OrderState>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return OrderViewModel(repo);
});

