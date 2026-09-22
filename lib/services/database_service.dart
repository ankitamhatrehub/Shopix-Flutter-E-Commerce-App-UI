import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/app_notification.dart';
import '../models/order.dart';
import '../models/payment_method.dart';
import '../models/shipping_address.dart';
import '../models/user_profile.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shoppix.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT,
        avatar_path TEXT,
        membership_tier TEXT,
        points INTEGER
      )
    ''');

    // Addresses table
    await db.execute('''
      CREATE TABLE addresses (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        recipient_name TEXT NOT NULL,
        phone TEXT NOT NULL,
        street TEXT NOT NULL,
        city TEXT NOT NULL,
        state TEXT NOT NULL,
        zip_code TEXT NOT NULL,
        is_default INTEGER NOT NULL
      )
    ''');

    // Payment methods table
    await db.execute('''
      CREATE TABLE payment_methods (
        id TEXT PRIMARY KEY,
        card_holder TEXT NOT NULL,
        card_number_masked TEXT NOT NULL,
        expiry_date TEXT NOT NULL,
        card_type TEXT NOT NULL,
        is_default INTEGER NOT NULL
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        order_number TEXT NOT NULL,
        date TEXT NOT NULL,
        total_amount REAL NOT NULL,
        status TEXT NOT NULL,
        item_count INTEGER NOT NULL,
        items_summary TEXT NOT NULL,
        address_title TEXT NOT NULL,
        payment_title TEXT NOT NULL
      )
    ''');

    // Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        time_ago TEXT NOT NULL,
        type TEXT NOT NULL,
        is_read INTEGER NOT NULL
      )
    ''');

    // Seed initial data
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    // Seed User
    const initialUser = UserProfile(
      id: 'usr_1',
      name: 'Ankita Shelke',
      email: 'ankita.shelke@example.com',
      phone: '+1 555-0199',
      avatarPath: null,
      membershipTier: 'Gold Member',
      points: 450,
    );
    await db.insert('users', initialUser.toMap());

    // Seed Addresses
    final initialAddresses = [
      const ShippingAddress(
        id: 'addr_1',
        title: 'Home',
        recipientName: 'Ankita Shelke',
        phone: '+1 555-0199',
        street: '742 Evergreen Terrace',
        city: 'Springfield',
        state: 'OR',
        zipCode: '97477',
        isDefault: true,
      ),
      const ShippingAddress(
        id: 'addr_2',
        title: 'Office',
        recipientName: 'Ankita Shelke',
        phone: '+1 555-0199',
        street: '404 Innovation Way, Tech Hub #300',
        city: 'Portland',
        state: 'OR',
        zipCode: '97201',
        isDefault: false,
      ),
    ];
    for (final addr in initialAddresses) {
      await db.insert('addresses', addr.toMap());
    }

    // Seed Payment Methods
    final initialCards = [
      const PaymentMethod(
        id: 'pm_1',
        cardHolder: 'Ankita Shelke',
        cardNumberMasked: '•••• •••• •••• 4242',
        expiryDate: '09/28',
        cardType: 'Mastercard',
        isDefault: true,
      ),
      const PaymentMethod(
        id: 'pm_2',
        cardHolder: 'Ankita Shelke',
        cardNumberMasked: '•••• •••• •••• 8819',
        expiryDate: '12/27',
        cardType: 'Visa',
        isDefault: false,
      ),
    ];
    for (final card in initialCards) {
      await db.insert('payment_methods', card.toMap());
    }

    // Seed Orders
    final initialOrders = [
      const Order(
        id: 'ord_1',
        orderNumber: 'SPX-8921',
        date: 'Sep 21, 2026',
        totalAmount: 139.99,
        status: OrderStatus.processing,
        itemCount: 1,
        itemsSummary: 'Nike Air Max Pulse Roam (x1)',
        addressTitle: 'Home (742 Evergreen Terr.)',
        paymentTitle: 'Mastercard ••• 4242',
      ),
      const Order(
        id: 'ord_2',
        orderNumber: 'SPX-7742',
        date: 'Sep 18, 2026',
        totalAmount: 349.99,
        status: OrderStatus.shipped,
        itemCount: 1,
        itemsSummary: 'Sony WH-1000XM5 ANC (x1)',
        addressTitle: 'Office (404 Innovation Way)',
        paymentTitle: 'Mastercard ••• 4242',
      ),
      const Order(
        id: 'ord_3',
        orderNumber: 'SPX-6103',
        date: 'Aug 29, 2026',
        totalAmount: 253.50,
        status: OrderStatus.delivered,
        itemCount: 2,
        itemsSummary: 'Minimalist Chrono Watch & Urban Hoodie',
        addressTitle: 'Home (742 Evergreen Terr.)',
        paymentTitle: 'Visa ••• 8819',
      ),
    ];
    for (final ord in initialOrders) {
      await db.insert('orders', ord.toMap());
    }

    // Seed Notifications
    final initialNotifications = [
      const AppNotification(
        id: 'notif_1',
        title: 'Order Confirmed! 📦',
        message: 'Your order #SPX-8921 has been placed and is currently being packed.',
        timeAgo: '10 min ago',
        type: NotificationType.order,
        isRead: false,
      ),
      const AppNotification(
        id: 'notif_2',
        title: 'Special 20% Discount Code! 🎉',
        message: 'Use code SHOPPIX20 on your next electronics or sneakers order.',
        timeAgo: '2 hours ago',
        type: NotificationType.promo,
        isRead: false,
      ),
      const AppNotification(
        id: 'notif_3',
        title: 'Package Shipped 🚚',
        message: 'Your Sony WH-1000XM5 headphones are on their way via Express.',
        timeAgo: '1 day ago',
        type: NotificationType.order,
        isRead: true,
      ),
    ];
    for (final notif in initialNotifications) {
      await db.insert('notifications', notif.toMap());
    }
  }

  // --- Users CRUD ---
  Future<UserProfile?> getUser() async {
    final db = await database;
    final results = await db.query('users', limit: 1);
    if (results.isNotEmpty) {
      return UserProfile.fromMap(results.first);
    }
    return null;
  }

  Future<void> saveUser(UserProfile user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUserAvatar(String avatarPath) async {
    final db = await database;
    await db.update('users', {'avatar_path': avatarPath});
  }

  // --- Addresses CRUD ---
  Future<List<ShippingAddress>> getAddresses() async {
    final db = await database;
    final results = await db.query('addresses', orderBy: 'is_default DESC');
    return results.map((m) => ShippingAddress.fromMap(m)).toList();
  }

  Future<void> insertAddress(ShippingAddress address) async {
    final db = await database;
    if (address.isDefault) {
      await db.update('addresses', {'is_default': 0});
    }
    await db.insert(
      'addresses',
      address.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAddress(ShippingAddress address) async {
    final db = await database;
    if (address.isDefault) {
      await db.update('addresses', {'is_default': 0});
    }
    await db.update(
      'addresses',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  Future<void> deleteAddress(String id) async {
    final db = await database;
    await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }

  // --- Payment Methods CRUD ---
  Future<List<PaymentMethod>> getPaymentMethods() async {
    final db = await database;
    final results = await db.query('payment_methods', orderBy: 'is_default DESC');
    return results.map((m) => PaymentMethod.fromMap(m)).toList();
  }

  Future<void> insertPaymentMethod(PaymentMethod card) async {
    final db = await database;
    if (card.isDefault) {
      await db.update('payment_methods', {'is_default': 0});
    }
    await db.insert(
      'payment_methods',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> setDefaultPaymentMethod(String id) async {
    final db = await database;
    await db.update('payment_methods', {'is_default': 0});
    await db.update(
      'payment_methods',
      {'is_default': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletePaymentMethod(String id) async {
    final db = await database;
    await db.delete('payment_methods', where: 'id = ?', whereArgs: [id]);
  }

  // --- Orders CRUD ---
  Future<List<Order>> getOrders() async {
    final db = await database;
    final results = await db.query('orders', orderBy: 'rowid DESC');
    return results.map((m) => Order.fromMap(m)).toList();
  }

  Future<void> insertOrder(Order order) async {
    final db = await database;
    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // --- Notifications CRUD ---
  Future<List<AppNotification>> getNotifications() async {
    final db = await database;
    final results = await db.query('notifications', orderBy: 'rowid DESC');
    return results.map((m) => AppNotification.fromMap(m)).toList();
  }

  Future<void> markNotificationAsRead(String id) async {
    final db = await database;
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markAllNotificationsAsRead() async {
    final db = await database;
    await db.update('notifications', {'is_read': 1});
  }
}

