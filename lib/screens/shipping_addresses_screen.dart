import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shipping_address.dart';
import '../theme/app_theme.dart';
import '../viewmodels/address_viewmodel.dart';

class ShippingAddressesScreen extends ConsumerWidget {
  const ShippingAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressViewModelProvider);
    final addresses = addressState.addresses;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Shipping Addresses'),
      ),
      body: addresses.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off_outlined,
                        size: 64, color: AppTheme.textSecondary),
                    const SizedBox(height: 16),
                    const Text(
                      'No Addresses Saved',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add an address to ensure swift deliveries for your orders.',
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
              itemCount: addresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final addr = addresses[index];
                final isSelected =
                    addressState.selectedAddressId == addr.id;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                addr.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              if (addr.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
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
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    size: 18, color: AppTheme.textSecondary),
                                onPressed: () {
                                  _showAddressDialog(context, ref, address: addr);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded,
                                    size: 18, color: AppTheme.accent),
                                onPressed: () {
                                  ref
                                      .read(addressViewModelProvider.notifier)
                                      .deleteAddress(addr.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${addr.recipientName} • ${addr.phone}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        addr.fullAddress,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          ref
                              .read(addressViewModelProvider.notifier)
                              .selectAddress(addr.id);
                        },
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isSelected
                                  ? 'Selected for delivery'
                                  : 'Select this address',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
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
              _showAddressDialog(context, ref);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add New Address'),
          ),
        ),
      ),
    );
  }

  void _showAddressDialog(BuildContext context, WidgetRef ref,
      {ShippingAddress? address}) {
    final titleCtrl = TextEditingController(text: address?.title ?? 'Home');
    final nameCtrl = TextEditingController(
        text: address?.recipientName ?? 'Ankita Shelke');
    final phoneCtrl =
        TextEditingController(text: address?.phone ?? '+1 555-0199');
    final streetCtrl = TextEditingController(
        text: address?.street ?? '123 Main Street, Apt 4B');
    final cityCtrl =
        TextEditingController(text: address?.city ?? 'Portland');
    final stateCtrl = TextEditingController(text: address?.state ?? 'OR');
    final zipCtrl = TextEditingController(text: address?.zipCode ?? '97201');
    bool isDef = address?.isDefault ?? false;

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
                    Text(
                      address == null ? 'Add New Address' : 'Edit Address',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Label (e.g. Home, Office, Parents)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Recipient Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: streetCtrl,
                      decoration: const InputDecoration(labelText: 'Street Address'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cityCtrl,
                            decoration: const InputDecoration(labelText: 'City'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: stateCtrl,
                            decoration: const InputDecoration(labelText: 'State'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: zipCtrl,
                            decoration: const InputDecoration(labelText: 'Zip Code'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Set as default delivery address'),
                      value: isDef,
                      onChanged: (val) => setSheetState(() => isDef = val),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final newAddr = ShippingAddress(
                            id: address?.id ??
                                'addr_${DateTime.now().millisecondsSinceEpoch}',
                            title: titleCtrl.text.trim(),
                            recipientName: nameCtrl.text.trim(),
                            phone: phoneCtrl.text.trim(),
                            street: streetCtrl.text.trim(),
                            city: cityCtrl.text.trim(),
                            state: stateCtrl.text.trim(),
                            zipCode: zipCtrl.text.trim(),
                            isDefault: isDef,
                          );

                          if (address == null) {
                            await ref
                                .read(addressViewModelProvider.notifier)
                                .addAddress(newAddr);
                          } else {
                            await ref
                                .read(addressViewModelProvider.notifier)
                                .updateAddress(newAddr);
                          }
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        child: Text(address == null
                            ? 'Save Address'
                            : 'Update Address'),
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

