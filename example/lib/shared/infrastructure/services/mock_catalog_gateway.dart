import 'package:super_pagination/super_pagination.dart';
import 'package:super_pagination_example/shared/application/contracts/demo_catalog_gateway.dart';
import 'package:super_pagination_example/shared/domain/entities/product.dart';
import 'package:super_pagination_example/shared/infrastructure/services/mock_api_service.dart';

/// In-memory implementation used by the example application.
final class MockCatalogGateway implements DemoCatalogGateway {
  final MockApiService _legacyService = MockApiService();

  @override
  Future<List<Product>> fetchProducts(
    SuperPaginationRequest request, {
    bool simulateError = false,
  }) =>
      MockApiService.fetchProducts(request, simulateError: simulateError);

  @override
  Future<List<Product>> fetchProductsWithError(SuperPaginationRequest request) =>
      _legacyService.fetchProductsWithError(request);

  @override
  Future<List<Product>> searchProducts(
    String query, {
    int pageSize = 20,
  }) =>
      MockApiService.searchProducts(query, pageSize: pageSize);

  @override
  Stream<List<Product>> productsStream(SuperPaginationRequest request) =>
      MockApiService.productsStream(request);

  @override
  Stream<List<Product>> regularProductsStream(SuperPaginationRequest request) =>
      MockApiService.regularProductsStream(request);

  @override
  Stream<List<Product>> featuredProductsStream(SuperPaginationRequest request) =>
      MockApiService.featuredProductsStream(request);

  @override
  Stream<List<Product>> saleProductsStream(SuperPaginationRequest request) =>
      MockApiService.saleProductsStream(request);

  @override
  Stream<List<Product>> accumulatingProductsStream(SuperPaginationRequest request) =>
      MockApiService.accumulatingProductsStream(request);

  @override
  Stream<List<Product>> unreliablePageStream(SuperPaginationRequest request) =>
      MockApiService.unreliablePageStream(request);
}
