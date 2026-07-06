import 'package:super_pagination_example/features/firebase_examples/application/contracts/seed_data_gateway.dart';
import 'package:super_pagination_example/features/firebase_examples/infrastructure/services/seed_data_service.dart';
import 'package:super_pagination_example/shared/application/contracts/demo_catalog_gateway.dart';
import 'package:super_pagination_example/shared/infrastructure/services/mock_catalog_gateway.dart';

/// Composition root for replaceable example dependencies.
abstract final class ExampleDependencies {
  static DemoCatalogGateway catalog = MockCatalogGateway();
  static SeedDataGateway seedData = SeedDataService();

  static void overrideCatalog(DemoCatalogGateway gateway) {
    catalog = gateway;
  }

  static void overrideSeedData(SeedDataGateway gateway) {
    seedData = gateway;
  }

  static void reset() {
    catalog = MockCatalogGateway();
    seedData = SeedDataService();
  }
}
