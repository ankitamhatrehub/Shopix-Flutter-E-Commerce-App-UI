class PaymentMethod {
  final String id;
  final String cardHolder;
  final String cardNumberMasked; // e.g. "•••• •••• •••• 4242"
  final String expiryDate; // e.g. "08/28"
  final String cardType; // "Visa", "Mastercard", "Amex"
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.cardHolder,
    required this.cardNumberMasked,
    required this.expiryDate,
    required this.cardType,
    this.isDefault = false,
  });

  PaymentMethod copyWith({
    String? id,
    String? cardHolder,
    String? cardNumberMasked,
    String? expiryDate,
    String? cardType,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      cardHolder: cardHolder ?? this.cardHolder,
      cardNumberMasked: cardNumberMasked ?? this.cardNumberMasked,
      expiryDate: expiryDate ?? this.expiryDate,
      cardType: cardType ?? this.cardType,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'card_holder': cardHolder,
      'card_number_masked': cardNumberMasked,
      'expiry_date': expiryDate,
      'card_type': cardType,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] as String,
      cardHolder: map['card_holder'] as String,
      cardNumberMasked: map['card_number_masked'] as String,
      expiryDate: map['expiry_date'] as String,
      cardType: map['card_type'] as String,
      isDefault: (map['is_default'] as int? ?? 0) == 1,
    );
  }
}

