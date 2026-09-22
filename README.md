# Shoppix — Next-Gen 3D Mobile Shopping App

<p align="center">
  <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80" alt="Shoppix App Banner" width="100%" style="border-radius: 16px; max-height: 280px; object-fit: cover;" />
</p>

<p align="center">
  <b>A modern, high-performance Flutter e-commerce application powered by Riverpod state management, strict MVVM architecture, SQLite local persistence, and an immersive dynamic 3D glassmorphic UI.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Riverpod-3.4.3-blue?logo=dart&logoColor=white" alt="Riverpod" />
  <img src="https://img.shields.io/badge/Architecture-MVVM-6366F1" alt="Architecture" />
  <img src="https://img.shields.io/badge/Local_DB-SQLite_%28sqflite%29-003B57?logo=sqlite&logoColor=white" alt="SQLite" />
  <img src="https://img.shields.io/badge/UI_Style-3D_Perspective_%26_Glassmorphism-FF4757" alt="UI" />
</p>

---

## 🌟 Key Highlights & Features

### 1. 🌌 Unified 3D Splash & Interactive Onboarding
- **Phase 1 (Splash)**: Isometric 3D pulsing cube logo rendered with `Matrix4` 3D perspective rotation, scale bounce, glowing aurora background orbs, and brand typography.
- **Phase 2 (Onboarding)**: Seamlessly transitions into a 3D glassmorphic card carousel (`GlassCard` with real-time perspective tilt) showcasing:
  - *Discover 3D Trending Styles*
  - *Lightning Fast Express Delivery*
  - *One-Tap Secure Smart Checkout*
- **Navigation Controls**: Includes **Skip**, **Next**, **Guest Mode**, and **Get Started** (routes directly to authentication).

### 2. 🔐 Complete End-to-End Authentication Flow
- **Login Screen**: 3D floating glass card with email/password validation, SQLite user caching, and Guest Mode fallback.
- **Register Screen**: Full registration form (Full Name, Email, Phone, Password) with immediate SQLite auto-caching and auto-login.
- **Forgot Password**: 3D floating lock visual with email lookup.
- **OTP Verification**: 6-digit glowing 3D perspective PIN boxes with auto-submit and countdown timer.
- **Logout**: Safe session clearance with redirection back to the login screen.

### 3. 💎 Dynamic 3D UI & Glassmorphism Design System
- **`GlassCard`**: Custom reusable container leveraging `Matrix4.identity()..setEntry(3, 2, 0.002)..rotateX(tiltX)..rotateY(tiltY)`, `BackdropFilter` gaussian blur, specular border highlights, and multi-tier neon drop shadows.
- **`ProductCard`**: Floating elevated cards with 3D thumbnail perspective, glassmorphic discount badges, and floating circular quick-add buttons.
- **`PromoBanner`**: Real-time perspective yaw rotation carousel (`Matrix4..rotateY`) with specular gloss reflections and responsive slide indicators.

### 4. 🛒 Rich Catalog, Search & Direct Checkout
- **Flash Sale Section**: Animated live countdown timer with horizontal 3D product cards.
- **Explore & Filtering**: Live search, category chips, price range slider, and sort filters (Popular, Price Low-High, Price High-Low, Top Rated).
- **Product Details Screen**: Collapsible 3D hero image, multi-variant options (colors and sizes), quantity stepper, and **Direct "Buy Now"** button routing straight to Checkout.
- **Cart Screen**: Itemized cart list, stepper controls, promo discount voucher system (`SHOPPIX20` for 20% off), subtotal, and tax/shipping breakdown.
- **Dedicated Checkout Screen**: Address selector, multi-payment options (Card, Digital Wallet, Cash on Delivery), order items summary, and total calculation.
- **Order Success Screen**: 3D animated checkmark receipt with order number, estimated delivery date, and instant order tracking navigation.

### 5. 📷 User Profile & Photo Upload (`image_picker`)
- **Avatar Photo Upload**: Integrated with `image_picker` allowing users to:
  - Take a new photo via **Camera**
  - Select an existing photo from **Gallery**
  - **Remove** photo to revert to the default monogram avatar
- **Offline Persistence**: Photo paths and profile information are automatically saved to SQLite (`shoppix.db`).

### 6. 📦 Standalone Management Screens
- **`MyOrdersScreen`**: Filterable status tabs (*All*, *Processing*, *Shipped*, *Delivered*) synced with local SQLite database.
- **`ShippingAddressesScreen`**: Saved delivery addresses with `DEFAULT` indicator badges and an interactive Add/Edit Address bottom sheet.
- **`PaymentMethodsScreen`**: 3D visual credit/debit card rendering (Visa & Mastercard) with an Add Card bottom sheet.
- **`NotificationsScreen`**: Categorized notifications (*All*, *Promo*, *Order*, *Account*) with unread badge counters and mark-as-read actions.

---

## 🏛️ Architecture & Design Pattern (MVVM)

This project strictly adheres to **Model - View - ViewModel (MVVM)** powered by **Flutter Riverpod**:

```
┌─────────────────────────────────────────────────────────────┐
│                          VIEWS                              │
│   (Screens & ConsumerWidgets: observing state via ref.watch) │
└──────────────────────────────┬──────────────────────────────┘
                               │ User Actions (ref.read)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                       VIEWMODELS                            │
│   (StateNotifiers: Cart, Auth, Catalog, Orders, Addresses)  │
└──────────────────────────────┬──────────────────────────────┘
                               │ Queries & Mutations
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      REPOSITORIES                           │
│   (ProductRepo, UserRepo, OrderRepo, PaymentRepo, etc.)     │
└──────────────────────────────┬──────────────────────────────┘
                               │ Read / Write
                               ▼
┌─────────────────────────────────────────────────────────────┐
│               LOCAL DATABASE & HARDWARE SERVICES            │
│   (DatabaseService: SQLite, ImagePickerService: Camera)     │
└─────────────────────────────────────────────────────────────┘
```

- **Models (`lib/models/`)**: Strongly-typed, immutable data models (`Product`, `CartItem`, `UserProfile`, `Order`, `ShippingAddress`, `PaymentMethod`, `AppNotification`) with `toMap()` / `fromMap()` for SQLite serialization.
- **Services (`lib/services/`)**:
  - `DatabaseService`: Singleton managing `shoppix.db`, database migrations, and realistic seed data.
  - `ImagePickerService`: Hardware camera & gallery access abstractions.
- **Repositories (`lib/repositories/`)**: Decoupled data access layer abstracting database tables and in-memory caches.
- **ViewModels (`lib/viewmodels/`)**: Riverpod `StateNotifier` and `StateProvider` instances managing reactive UI states (Cart count, totals, auth status, active filters, order placement).
- **Views (`lib/screens/` & `lib/widgets/`)**: Declarative UI components rebuilt reactively without state coupling.

---

## 📁 Project Structure

```
shoppix_frontend/
├── lib/
│   ├── main.dart                      # Application entry point with ProviderScope
│   ├── models/                        # Domain entities
│   │   ├── app_notification.dart
│   │   ├── cart_item.dart
│   │   ├── category.dart
│   │   ├── order.dart
│   │   ├── payment_method.dart
│   │   ├── product.dart
│   │   ├── shipping_address.dart
│   │   └── user_profile.dart
│   ├── services/                      # SQLite & Device hardware services
│   │   ├── database_service.dart      # SQLite singleton & schema management
│   │   └── image_picker_service.dart  # Camera & Gallery photo picker
│   ├── repositories/                  # Data access layer
│   │   ├── address_repository.dart
│   │   ├── notification_repository.dart
│   │   ├── order_repository.dart
│   │   ├── payment_repository.dart
│   │   ├── product_repository.dart
│   │   └── user_repository.dart
│   ├── viewmodels/                    # Riverpod StateNotifiers
│   │   ├── address_viewmodel.dart
│   │   ├── auth_viewmodel.dart
│   │   ├── cart_viewmodel.dart
│   │   ├── catalog_viewmodel.dart
│   │   ├── navigation_viewmodel.dart
│   │   ├── notification_viewmodel.dart
│   │   ├── order_viewmodel.dart
│   │   ├── payment_viewmodel.dart
│   │   └── wishlist_viewmodel.dart
│   ├── theme/
│   │   └── app_theme.dart             # Color palette, 3D shadows & typography
│   ├── widgets/                       # Reusable 3D & UI components
│   │   ├── category_chip.dart
│   │   ├── glass_card.dart            # Matrix4 3D perspective tilt & BackdropFilter
│   │   ├── product_card.dart          # 3D floating thumbnail & animated cart action
│   │   └── promo_banner.dart          # 3D perspective yaw rotation carousel
│   └── screens/
│       ├── splash_onboarding_screen.dart # Unified 3D Logo Splash + Onboarding
│       ├── main_navigation_screen.dart   # 5-Tab Navigation Scaffold
│       ├── home_screen.dart              # 3D Banner, Flash Sale, Popular Grid
│       ├── explore_screen.dart           # Search, Category Filters, Price Slider
│       ├── product_detail_screen.dart    # 3D Hero, Specs, Direct 'Buy Now'
│       ├── cart_screen.dart              # Cart Stepper, SHOPPIX20 promo, Checkout
│       ├── checkout_screen.dart          # Full Order Placement Screen
│       ├── order_success_screen.dart     # Order Confirmation & Receipt
│       ├── my_orders_screen.dart         # Order tracking & past history
│       ├── shipping_addresses_screen.dart# Address management & Add Address sheet
│       ├── payment_methods_screen.dart   # 3D Credit/Debit Card management
│       ├── notifications_screen.dart     # Order & Promo updates
│       ├── profile_screen.dart           # Avatar photo upload & account settings
│       └── auth/
│           ├── login_screen.dart         # 3D Glass card login & Guest Mode
│           ├── register_screen.dart      # 3D Registration with SQLite auto-cache
│           ├── forgot_password_screen.dart # 3D Floating lock email lookup
│           └── otp_verification_screen.dart# 6-Digit glowing 3D PIN boxes
└── test/
    └── widget_test.dart               # Widget tests for Splash, Onboarding & Tabs
```

---

## 💾 Local SQLite Database Schema

Shoppix uses an offline-first SQLite database (`shoppix.db`) with the following tables:

| Table | Description |
|---|---|
| `users` | Stores user credentials, email, phone, and avatar photo path |
| `shipping_addresses` | User delivery addresses with default selection flag |
| `payment_methods` | Saved payment cards with card type, masked number, and expiry |
| `orders` | Completed orders with order number, item summary, total, and status |
| `app_notifications` | In-app alerts, promo vouchers, and delivery updates |

---

## 🛠️ Tech Stack & Key Packages

- **Framework**: [Flutter](https://flutter.dev/) (Channel stable, Material 3)
- **State Management**: [`flutter_riverpod: ^3.4.3`](https://pub.dev/packages/flutter_riverpod)
- **Local Database**: [`sqflite: ^2.4.4`](https://pub.dev/packages/sqflite)
- **Path Utilities**: [`path: ^1.9.1`](https://pub.dev/packages/path) & [`path_provider: ^2.1.5`](https://pub.dev/packages/path_provider)
- **Image Picker**: [`image_picker: ^1.2.1`](https://pub.dev/packages/image_picker)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (version >= 3.0.0)
- Dart SDK (version >= 3.0.0)
- Android Studio / Xcode / VS Code with Flutter extension

### Installation & Run

1. **Navigate to the frontend folder**:
   ```bash
   cd shoppix_frontend
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

4. **Run Static Code Analysis**:
   ```bash
   flutter analyze
   ```

5. **Run Widget Tests**:
   ```bash
   flutter test
   ```

---

## 🧪 Testing

The test suite in [`test/widget_test.dart`](test/widget_test.dart) verifies:
- Initial rendering of the 3D brand splash logo (`SHOPPIX`).
- Automatic transition into the 3D onboarding carousel after the splash timer.
- Tapping **Skip** to transition to the main 5-tab shopping interface.
- Tab switching across **Home**, **Explore**, **Cart**, **Wishlist**, and **Account**.

---

<p align="center">
  Crafted with ❤️ for the next-generation shopping experience.
</p>
