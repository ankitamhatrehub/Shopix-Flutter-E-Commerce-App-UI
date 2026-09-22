import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../services/database_service.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<void> createOrder(Order order);
}

class SqliteOrderRepository implements OrderRepository {
  final DatabaseService _db = DatabaseService.instance;

  @override
  Future<List<Order>> getOrders() => _db.getOrders();

  @override
  Future<void> createOrder(Order order) => _db.insertOrder(order);
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return SqliteOrderRepository();
});

