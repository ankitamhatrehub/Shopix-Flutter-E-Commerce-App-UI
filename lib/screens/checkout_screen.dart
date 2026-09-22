import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../viewmodels/address_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/order_viewmodel.dart';
import '../viewmodels/payment_viewmodel.dart';
import 'order_success_screen.dart';
import 'shipping_addresses_screen.dart';
import 'payment_methods_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentType = 'Card'; // 'Card', 'UPI', 'COD'
  bool _isProcessing = false;

  Future<void> _handlePlaceOrder() async {
    final cartState = ref.read(cartViewModelProvider);
    if (cartState.items.isEmpty) return;

    final selectedAddress =
        ref.read(addressViewModelProvider).selectedAddress;
    final selectedPayment =
        ref.read(paymentViewModelProvider).selectedMethod;

    final addressTitle = selectedAddress != null
        ? '${selectedAddress.title} (${selectedAddress.city})'
        : '742 Evergreen Terr.';

    final paymentTitle = _selectedPaymentType == 'Card' && selectedPayment != null
        ? '${selectedPayment.cardType} ${selectedPayment.cardNumberMasked}'
        : _selectedPaymentType;

    final itemsSummary = cartState.items
        .map((i) => '${i.product.title} (x${i.quantity})')
        .take(2)
        .join(', ');

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    final order = await ref.read(orderViewModelProvider.notifier).placeOrder(
          totalAmount: cartState.total,
          itemCount: cartState.cartCount,
          itemsSummary: itemsSummary,
          addressTitle: addressTitle,
          paymentTitle: paymentTitle,
        );

    ref.read(cartViewModelProvider.notifier).clearCart();

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderSuccessScreen(order: order),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);
    final addressState = ref.watch(addressViewModelProvider);
    final paymentState = ref.watch(paymentViewModelProvider);

    final currentAddress = addressState.selectedAddress;
    final currentCard = paymentState.selectedMethod;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Shipping Address Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Shipping Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ShippingAddressesScreen(),
                      ),
                    );
                  },
                  child: const Text('Change'),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: currentAddress == null
                  ? const Text('No address selected')
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.location_on_rounded,
                              color: AppTheme.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    currentAddress.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  if (currentAddress.isDefault) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'DEFAULT',
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${currentAddress.recipientName} • ${currentAddress.phone}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currentAddress.fullAddress,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // 2. Payment Method Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodsScreen(),
                      ),
                    );
                  },
                  child: const Text('Manage Cards'),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.primary,
                    title: Row(
                      children: [
                        const Icon(Icons.credit_card_rounded,
                            color: AppTheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          currentCard != null
                              ? '${currentCard.cardType} (${currentCard.cardNumberMasked})'
                              : 'Credit / Debit Card',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    value: 'Card',
                    groupValue: _selectedPaymentType,
                    onChanged: (val) => setState(() => _selectedPaymentType = val!),
                  ),
                  const Divider(height: 12, color: AppTheme.border),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.primary,
                    title: const Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            color: AppTheme.textSecondary),
                        SizedBox(width: 10),
                        Text(
                          'Apple Pay / Google Pay',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    value: 'Digital Wallet',
                    groupValue: _selectedPaymentType,
                    onChanged: (val) => setState(() => _selectedPaymentType = val!),
                  ),
                  const Divider(height: 12, color: AppTheme.border),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.primary,
                    title: const Row(
                      children: [
                        Icon(Icons.payments_outlined,
                            color: AppTheme.textSecondary),
                        SizedBox(width: 10),
                        Text(
                          'Cash on Delivery',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    value: 'Cash on Delivery',
                    groupValue: _selectedPaymentType,
                    onChanged: (val) => setState(() => _selectedPaymentType = val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Order Items Summary
            const Text(
              'Order Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(14),
                itemCount: cartState.items.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 20, color: AppTheme.border),
                itemBuilder: (context, index) {
                  final item = cartState.items[index];
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: const Color(0xFFF1F5F9),
                          child: Image.network(
                            item.product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.shopping_bag_outlined,
                                    color: AppTheme.textSecondary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Qty: ${item.quantity} • ${item.selectedSize ?? "Std"}',
                              style: const TextStyle(
                                  fontSize: 11, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 4. Payment Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  _buildCostRow('Subtotal', '\$${cartState.subtotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildCostRow(
                    'Shipping',
                    cartState.shippingFee == 0
                        ? 'FREE'
                        : '\$${cartState.shippingFee.toStringAsFixed(2)}',
                    isFree: cartState.shippingFee == 0,
                  ),
                  if (cartState.discountAmount > 0) ...[
                    const SizedBox(height: 8),
                    _buildCostRow(
                      'Promo Discount',
                      '-\$${cartState.discountAmount.toStringAsFixed(2)}',
                      isDiscount: true,
                    ),
                  ],
                  const Divider(height: 24, color: AppTheme.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Payment',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary),
                      ),
                      Text(
                        '\$${cartState.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _handlePlaceOrder,
              child: _isProcessing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Pay & Place Order • \$${cartState.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value,
      {bool isFree = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDiscount ? AppTheme.accent : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isFree
                ? AppTheme.success
                : (isDiscount ? AppTheme.accent : AppTheme.textPrimary),
          ),
        ),
      ],
    );
  }
}

