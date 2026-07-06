import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_pagination_example/features/firebase_examples/application/contracts/seed_data_gateway.dart';
import 'package:super_pagination_example/features/firebase_examples/presentation/controllers/seed_data_controller.dart';
import 'package:super_pagination_example/features/home/presentation/controllers/home_controller.dart';
import 'package:super_pagination_example/features/home/presentation/models/example_catalog.dart';

void main() {
  test('HomeController filters items by title and description', () {
    final controller = HomeController();
    const category = ExampleCategory(
      title: 'Examples',
      subtitle: 'Demo',
      icon: Icons.list,
      items: [
        ExampleItem(
          title: 'Grid pagination',
          description: 'Cards',
          icon: Icons.grid_view,
          color: Colors.blue,
          route: '/grid',
        ),
        ExampleItem(
          title: 'Search',
          description: 'Keyboard navigation',
          icon: Icons.search,
          color: Colors.green,
          route: '/search',
        ),
      ],
    );

    controller.searchController.text = 'keyboard';

    expect(controller.filterItems(category).single.route, '/search');
    controller.dispose();
  });

  test('SeedDataController exposes operation progress and result', () async {
    final controller = SeedDataController(_FakeSeedDataGateway());

    final result = await controller.seedProducts();

    expect(result.isSuccess, isTrue);
    expect(controller.isLoading, isFalse);
    expect(controller.logs, contains(contains('products')));
    controller.dispose();
  });
}

final class _FakeSeedDataGateway implements SeedDataGateway {
  @override
  Future<void> seedProducts({void Function(String message)? onProgress}) async {
    onProgress?.call('products seeded');
  }

  @override
  Future<void> clearAllData({void Function(String message)? onProgress}) async {}

  @override
  Future<void> seedAllData({void Function(String message)? onProgress}) async {}

  @override
  Future<void> seedMessages({void Function(String message)? onProgress}) async {}

  @override
  Future<void> seedPosts({void Function(String message)? onProgress}) async {}

  @override
  Future<void> seedUsers({void Function(String message)? onProgress}) async {}
}
