import 'package:flutter_test/flutter_test.dart';
import 'package:super_pagination_example/app/routing/app_router.dart' as current_router;
import 'package:super_pagination_example/features/home/presentation/pages/home_screen.dart'
    as current_home;
import 'package:super_pagination_example/models/product.dart' as legacy_model;
import 'package:super_pagination_example/router/app_router.dart' as legacy_router;
import 'package:super_pagination_example/screens/home_screen.dart' as legacy_home;
import 'package:super_pagination_example/shared/domain/entities/product.dart'
    as current_model;

void main() {
  test('legacy model path exports the current entity', () {
    final current = current_model.Product(
      id: '1',
      name: 'Product',
      description: 'Description',
      price: 10,
      category: 'Demo',
      imageUrl: '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    );

    final legacy_model.Product legacy = current;
    expect(legacy.id, '1');
  });

  test('legacy screen and router paths remain source compatible', () {
    const legacyScreen = legacy_home.HomeScreen();
    const currentScreen = current_home.HomeScreen();

    expect(legacyScreen, isA<current_home.HomeScreen>());
    expect(currentScreen, isA<legacy_home.HomeScreen>());
    expect(
      const legacy_router.BasicListViewRoute().location,
      const current_router.BasicListViewRoute().location,
    );
  });
}

