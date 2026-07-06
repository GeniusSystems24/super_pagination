import 'package:flutter/material.dart';

@immutable
final class ExampleItem {
  const ExampleItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;
}

@immutable
final class ExampleCategory {
  const ExampleCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.items,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<ExampleItem> items;
}
