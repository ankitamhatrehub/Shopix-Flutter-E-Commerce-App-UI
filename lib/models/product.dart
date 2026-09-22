import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewsCount;
  final String description;
  final String imageUrl;
  final List<Color> colors;
  final List<String> sizes;
  final String? tag; // e.g. "Sale 30%", "Hot", "New", "Trending"
  final bool isFeatured;
  final bool isFlashSale;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewsCount,
    required this.description,
    required this.imageUrl,
    this.colors = const [Colors.black, Colors.grey, Colors.indigo],
    this.sizes = const ['S', 'M', 'L', 'XL'],
    this.tag,
    this.isFeatured = false,
    this.isFlashSale = false,
  });

  int get discountPercentage {
    if (oldPrice == null || oldPrice! <= price) return 0;
    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }

  static const List<Product> sampleProducts = [
    Product(
      id: 'prod_1',
      title: 'Nike Air Max Pulse Roam',
      category: 'shoes',
      price: 139.99,
      oldPrice: 189.99,
      rating: 4.8,
      reviewsCount: 342,
      description:
          'Engineered for maximum street comfort and unmatched cushioning. Features durable textile and synthetic leather overlays with dynamic air units that absorb shocks with every stride.',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
      colors: [Colors.red, Colors.black, Colors.white],
      sizes: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
      tag: 'Sale 26%',
      isFeatured: true,
      isFlashSale: true,
    ),
    Product(
      id: 'prod_2',
      title: 'Sony WH-1000XM5 ANC',
      category: 'electronics',
      price: 349.99,
      oldPrice: 399.99,
      rating: 4.9,
      reviewsCount: 820,
      description:
          'Industry-leading wireless noise-canceling headphones with two processors, 8 microphones, and remarkable sound fidelity. 30-hour battery life with ultra-fast charging.',
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
      colors: [Colors.black, Color(0xFFD4AF37), Colors.blueGrey],
      sizes: ['Standard'],
      tag: 'Best Seller',
      isFeatured: true,
      isFlashSale: true,
    ),
    Product(
      id: 'prod_3',
      title: 'Minimalist Chrono Watch',
      category: 'watches',
      price: 189.00,
      oldPrice: 249.00,
      rating: 4.7,
      reviewsCount: 154,
      description:
          'Crafted from surgical-grade stainless steel with scratch-resistant sapphire crystal glass. Water-resistant up to 50 meters with precision Japanese quartz movement.',
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
      colors: [Colors.brown, Colors.black, Colors.blueGrey],
      sizes: ['38mm', '42mm'],
      tag: 'Trending',
      isFeatured: true,
      isFlashSale: false,
    ),
    Product(
      id: 'prod_4',
      title: 'Urban Oversized Hoodie',
      category: 'fashion',
      price: 64.50,
      oldPrice: 85.00,
      rating: 4.6,
      reviewsCount: 219,
      description:
          'Heavyweight French terry cotton blend with dropped shoulders and a relaxed drape. Pre-shrunk fabric ensures enduring shape after washing.',
      imageUrl:
          'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=800&q=80',
      colors: [Color(0xFF374151), Color(0xFFD1D5DB), Color(0xFF4F46E5)],
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      tag: 'Hot',
      isFeatured: true,
      isFlashSale: true,
    ),
    Product(
      id: 'prod_5',
      title: 'Leather Commuter Backpack',
      category: 'bags',
      price: 119.00,
      oldPrice: 159.00,
      rating: 4.8,
      reviewsCount: 96,
      description:
          'Full-grain artisan leather with dedicated padded compartment for 16-inch laptops. Ergonomic shoulder straps and luggage pass-through for effortless travel.',
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=800&q=80',
      colors: [Colors.brown, Colors.black],
      sizes: ['20L', '26L'],
      tag: 'Popular',
      isFeatured: false,
      isFlashSale: false,
    ),
    Product(
      id: 'prod_6',
      title: 'Adidas Ultraboost Light',
      category: 'shoes',
      price: 159.99,
      oldPrice: 190.00,
      rating: 4.7,
      reviewsCount: 412,
      description:
          'Experience epic energy return with the lightest Ultraboost ever made. Primeknit+ textile upper hugs your foot for supportive flexibility.',
      imageUrl:
          'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?auto=format&fit=crop&w=800&q=80',
      colors: [Colors.black, Colors.white, Colors.orange],
      sizes: ['US 8', 'US 9', 'US 10', 'US 11'],
      tag: 'New',
      isFeatured: true,
      isFlashSale: false,
    ),
    Product(
      id: 'prod_7',
      title: 'Apple iPad Air M2 11"',
      category: 'electronics',
      price: 599.00,
      rating: 4.9,
      reviewsCount: 520,
      description:
          'Supercharged by the Apple M2 chip. Gorgeous Liquid Retina display with True Tone, P3 wide color, and anti-reflective coating for stunning visuals.',
      imageUrl:
          'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
      colors: [Colors.blueGrey, Colors.purple, Colors.amber],
      sizes: ['128GB', '256GB', '512GB'],
      tag: 'Flagship',
      isFeatured: false,
      isFlashSale: false,
    ),
    Product(
      id: 'prod_8',
      title: 'Classic Denim Trucker Jacket',
      category: 'fashion',
      price: 79.99,
      oldPrice: 110.00,
      rating: 4.5,
      reviewsCount: 180,
      description:
          'Timeless 100% rigid cotton denim with dual chest flap pockets and adjustable waist tabs. A wardrobe cornerstone for year-round layering.',
      imageUrl:
          'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=800&q=80',
      colors: [Colors.indigo, Colors.black],
      sizes: ['S', 'M', 'L', 'XL'],
      tag: 'Sale 27%',
      isFeatured: false,
      isFlashSale: true,
    ),
  ];
}
