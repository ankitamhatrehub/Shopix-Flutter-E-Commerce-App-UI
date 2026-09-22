import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  static const List<Category> sampleCategories = [
    Category(id: 'all', name: 'All', icon: Icons.grid_view_rounded),
    Category(id: 'shoes', name: 'Shoes', icon: Icons.roller_skating_outlined),
    Category(id: 'electronics', name: 'Electronics', icon: Icons.headphones_outlined),
    Category(id: 'fashion', name: 'Fashion', icon: Icons.checkroom_outlined),
    Category(id: 'watches', name: 'Watches', icon: Icons.watch_outlined),
    Category(id: 'bags', name: 'Bags', icon: Icons.shopping_bag_outlined),
  ];
}
