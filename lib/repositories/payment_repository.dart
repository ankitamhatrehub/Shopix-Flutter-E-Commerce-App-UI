import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_method.dart';
import '../services/database_service.dart';

abstract class PaymentRepository {
  Future<List<PaymentMethod>> getPaymentMethods();
  Future<void> addPaymentMethod(PaymentMethod method);
  Future<void> setDefault(String id);
  Future<void> deletePaymentMethod(String id);
}

class SqlitePaymentRepository implements PaymentRepository {
  final DatabaseService _db = DatabaseService.instance;

  @override
  Future<List<PaymentMethod>> getPaymentMethods() => _db.getPaymentMethods();

  @override
  Future<void> addPaymentMethod(PaymentMethod method) =>
      _db.insertPaymentMethod(method);

  @override
  Future<void> setDefault(String id) => _db.setDefaultPaymentMethod(id);

  @override
  Future<void> deletePaymentMethod(String id) => _db.deletePaymentMethod(id);
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return SqlitePaymentRepository();
});

