class ShippingAddress {
  final String id;
  final String title; // e.g. "Home", "Office"
  final String recipientName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  const ShippingAddress({
    required this.id,
    required this.title,
    required this.recipientName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $state - $zipCode';

  ShippingAddress copyWith({
    String? id,
    String? title,
    String? recipientName,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      title: title ?? this.title,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'recipient_name': recipientName,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      id: map['id'] as String,
      title: map['title'] as String,
      recipientName: map['recipient_name'] as String,
      phone: map['phone'] as String,
      street: map['street'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zipCode: map['zip_code'] as String,
      isDefault: (map['is_default'] as int? ?? 0) == 1,
    );
  }
}

