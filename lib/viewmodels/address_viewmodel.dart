import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/shipping_address.dart';
import '../repositories/address_repository.dart';

class AddressState {
  final List<ShippingAddress> addresses;
  final String? selectedAddressId;
  final bool isLoading;

  const AddressState({
    this.addresses = const [],
    this.selectedAddressId,
    this.isLoading = false,
  });

  ShippingAddress? get selectedAddress {
    if (addresses.isEmpty) return null;
    if (selectedAddressId != null) {
      try {
        return addresses.firstWhere((a) => a.id == selectedAddressId);
      } catch (_) {}
    }
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return addresses.first;
    }
  }

  AddressState copyWith({
    List<ShippingAddress>? addresses,
    String? selectedAddressId,
    bool? isLoading,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddressViewModel extends StateNotifier<AddressState> {
  final AddressRepository _repo;

  AddressViewModel(this._repo) : super(const AddressState()) {
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    state = state.copyWith(isLoading: true);
    final list = await _repo.getAddresses();
    final defaultId = list.isNotEmpty
        ? list.firstWhere((a) => a.isDefault, orElse: () => list.first).id
        : null;
    state = state.copyWith(
      addresses: list,
      selectedAddressId: defaultId,
      isLoading: false,
    );
  }

  void selectAddress(String id) {
    state = state.copyWith(selectedAddressId: id);
  }

  Future<void> addAddress(ShippingAddress address) async {
    await _repo.addAddress(address);
    await loadAddresses();
  }

  Future<void> updateAddress(ShippingAddress address) async {
    await _repo.updateAddress(address);
    await loadAddresses();
  }

  Future<void> deleteAddress(String id) async {
    await _repo.deleteAddress(id);
    await loadAddresses();
  }
}

final addressViewModelProvider =
    StateNotifierProvider<AddressViewModel, AddressState>((ref) {
  final repo = ref.watch(addressRepositoryProvider);
  return AddressViewModel(repo);
});

