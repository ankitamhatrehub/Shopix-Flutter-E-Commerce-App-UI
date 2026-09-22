enum OrderStatus {
  processing,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String orderNumber;
  final String date;
  final double totalAmount;
  final OrderStatus status;
  final int itemCount;
  final String itemsSummary; // e.g. "Nike Air Max Pulse Roam (x1) & 1 more"
  final String addressTitle;
  final String paymentTitle;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.totalAmount,
    required this.status,
    required this.itemCount,
    required this.itemsSummary,
    required this.addressTitle,
    required this.paymentTitle,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_number': orderNumber,
      'date': date,
      'total_amount': totalAmount,
      'status': status.name,
      'item_count': itemCount,
      'items_summary': itemsSummary,
      'address_title': addressTitle,
      'payment_title': paymentTitle,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    OrderStatus parsedStatus;
    try {
      parsedStatus = OrderStatus.values.byName(map['status'] as String);
    } catch (_) {
      parsedStatus = OrderStatus.processing;
    }

    return Order(
      id: map['id'] as String,
      orderNumber: map['order_number'] as String,
      date: map['date'] as String,
      totalAmount: (map['total_amount'] as num).toDouble(),
      status: parsedStatus,
      itemCount: map['item_count'] as int,
      itemsSummary: map['items_summary'] as String,
      addressTitle: map['address_title'] as String,
      paymentTitle: map['payment_title'] as String,
    );
  }
}

