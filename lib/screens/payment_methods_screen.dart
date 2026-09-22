import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_method.dart';
import '../theme/app_theme.dart';
import '../viewmodels/payment_viewmodel.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentViewModelProvider);
    final cards = paymentState.methods;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: cards.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.credit_card_off_outlined,
                        size: 64, color: AppTheme.textSecondary),
                    const SizedBox(height: 16),
                    const Text(
                      'No Payment Cards Saved',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Save your cards securely for seamless one-tap checkout.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cards.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final card = cards[index];
                final isSelected =
                    paymentState.selectedMethodId == card.id;

                return _buildCardItem(context, ref, card, isSelected);
              },
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
          child: ElevatedButton.icon(
            onPressed: () {
              _showAddCardSheet(context, ref);
            },
            icon: const Icon(Icons.add_card_rounded),
            label: const Text('Add New Card'),
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, WidgetRef ref, PaymentMethod card,
      bool isSelected) {
    final isVisa = card.cardType.toLowerCase().contains('visa');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isVisa
              ? [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]
              : [const Color(0xFF312E81), const Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isVisa ? const Color(0xFF1E3A8A) : const Color(0xFF4F46E5))
                .withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Brand & Default / Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.cardType.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
              Row(
                children: [
                  if (card.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'DEFAULT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.white70, size: 20),
                    onPressed: () {
                      ref
                          .read(paymentViewModelProvider.notifier)
                          .deletePaymentMethod(card.id);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Chip icon
          Container(
            width: 36,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.amber.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.memory_rounded,
                size: 20, color: Color(0xFF854D0E)),
          ),
          const SizedBox(height: 18),

          // Card Number
          Text(
            card.cardNumberMasked,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 18),

          // Holder and Expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.cardHolder,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.expiryDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 20, color: Colors.white24),

          // Selection
          InkWell(
            onTap: () {
              ref.read(paymentViewModelProvider.notifier).selectPayment(card.id);
              if (!card.isDefault) {
                ref.read(paymentViewModelProvider.notifier).setDefault(card.id);
              }
            },
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  isSelected ? 'Selected for Payments' : 'Make Default Card',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCardSheet(BuildContext context, WidgetRef ref) {
    final holderCtrl = TextEditingController(text: 'Ankita Shelke');
    final numberCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();
    String cardType = 'Mastercard';
    bool isDefault = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Card',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: holderCtrl,
                      decoration: const InputDecoration(labelText: 'Card Holder Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: numberCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        hintText: '1234 5678 9012 3456',
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: expiryCtrl,
                            keyboardType: TextInputType.datetime,
                            maxLength: 5,
                            decoration: const InputDecoration(
                              labelText: 'Expiry (MM/YY)',
                              hintText: '09/28',
                              counterText: '',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: cvvCtrl,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              counterText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: cardType,
                      decoration: const InputDecoration(labelText: 'Card Brand'),
                      items: const [
                        DropdownMenuItem(
                            value: 'Mastercard', child: Text('Mastercard')),
                        DropdownMenuItem(value: 'Visa', child: Text('Visa')),
                        DropdownMenuItem(
                            value: 'American Express',
                            child: Text('American Express')),
                      ],
                      onChanged: (val) =>
                          setSheetState(() => cardType = val!),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Set as default payment card'),
                      value: isDefault,
                      onChanged: (val) =>
                          setSheetState(() => isDefault = val),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final last4 = numberCtrl.text.length >= 4
                              ? numberCtrl.text.substring(numberCtrl.text.length - 4)
                              : '1234';
                          final newCard = PaymentMethod(
                            id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
                            cardHolder: holderCtrl.text.trim(),
                            cardNumberMasked: '•••• •••• •••• $last4',
                            expiryDate: expiryCtrl.text.trim().isEmpty
                                ? '12/28'
                                : expiryCtrl.text.trim(),
                            cardType: cardType,
                            isDefault: isDefault,
                          );
                          await ref
                              .read(paymentViewModelProvider.notifier)
                              .addPaymentMethod(newCard);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        child: const Text('Save Card'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

