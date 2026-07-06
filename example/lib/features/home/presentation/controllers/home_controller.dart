import 'package:flutter/material.dart';
import 'package:super_pagination_example/features/home/presentation/models/example_catalog.dart';

/// Presentation controller for filtering the example catalog.
final class HomeController extends ChangeNotifier {
  HomeController() {
    searchController.addListener(_onSearchChanged);
  }

  final TextEditingController searchController = TextEditingController();

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  List<ExampleItem> filterItems(ExampleCategory category) {
    if (_searchQuery.isEmpty) return category.items;

    return category.items.where((item) {
      return item.title.toLowerCase().contains(_searchQuery) ||
          item.description.toLowerCase().contains(_searchQuery);
    }).toList(growable: false);
  }

  void clearSearch() => searchController.clear();

  void _onSearchChanged() {
    final nextQuery = searchController.text.trim().toLowerCase();
    if (nextQuery == _searchQuery) return;
    _searchQuery = nextQuery;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }
}
