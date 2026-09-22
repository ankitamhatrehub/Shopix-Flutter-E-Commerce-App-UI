import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shipping_address.dart';
import '../services/database_service.dart';

abstract class AddressRepository {
  Future<List<ShippingAddress>> getAddresses();
  Future<void> addAddress(ShippingAddress address);
  Future<void> updateAddress(ShippingAddress address);
  Future<void> deleteAddress(String id);
}

class SqliteAddressRepository implements AddressRepository {
  final DatabaseService _db = DatabaseService.instance;

  @override
  Future<List<ShippingAddress>> getAddresses() => _db.getAddresses();

  @override
  Future<void> addAddress(ShippingAddress address) => _db.insertAddress(address);

  @override
  Future<void> updateAddress(ShippingAddress address) =>
      _db.updateAddress(address);

  @override
  Future<void> deleteAddress(String id) => _db.deleteAddress(id);
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return SqliteAddressRepository();
});

