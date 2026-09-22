import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/payment_method.dart';
import '../repositories/payment_repository.dart';

class PaymentState {
  final List<PaymentMethod> methods;
  final String? selectedMethodId;
  final bool isLoading;

  const PaymentState({
    this.methods = const [],
    this.selectedMethodId,
    this.isLoading = false,
  });

  PaymentMethod? get selectedMethod {
    if (methods.isEmpty) return null;
    if (selectedMethodId != null) {
      try {
        return methods.firstWhere((m) => m.id == selectedMethodId);
      } catch (_) {}
    }
    try {
      return methods.firstWhere((m) => m.isDefault);
    } catch (_) {
      return methods.first;
    }
  }

  PaymentState copyWith({
    List<PaymentMethod>? methods,
    String? selectedMethodId,
    bool? isLoading,
  }) {
    return PaymentState(
      methods: methods ?? this.methods,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PaymentViewModel extends StateNotifier<PaymentState> {
  final PaymentRepository _repo;

  PaymentViewModel(this._repo) : super(const PaymentState()) {
    loadPaymentMethods();
  }

  Future<void> loadPaymentMethods() async {
    state = state.copyWith(isLoading: true);
    final list = await _repo.getPaymentMethods();
    final defaultId = list.isNotEmpty
        ? list.firstWhere((m) => m.isDefault, orElse: () => list.first).id
        : null;
    state = state.copyWith(
      methods: list,
      selectedMethodId: defaultId,
      isLoading: false,
    );
  }

  void selectPayment(String id) {
    state = state.copyWith(selectedMethodId: id);
  }

  Future<void> addPaymentMethod(PaymentMethod method) async {
    await _repo.addPaymentMethod(method);
    await loadPaymentMethods();
  }

  Future<void> setDefault(String id) async {
    await _repo.setDefault(id);
    await loadPaymentMethods();
  }

  Future<void> deletePaymentMethod(String id) async {
    await _repo.deletePaymentMethod(id);
    await loadPaymentMethods();
  }
}

final paymentViewModelProvider =
    StateNotifierProvider<PaymentViewModel, PaymentState>((ref) {
  final repo = ref.watch(paymentRepositoryProvider);
  return PaymentViewModel(repo);
});

