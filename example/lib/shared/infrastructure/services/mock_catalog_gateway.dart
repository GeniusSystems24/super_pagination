import 'package:super_pagination/super_pagination.dart';
import 'package:super_pagination_example/shared/application/contracts/demo_catalog_gateway.dart';
import 'package:super_pagination_example/shared/domain/entities/product.dart';
import 'package:super_pagination_example/shared/infrastructure/services/mock_api_service.dart';

/// In-memory implementation used by the example application.
final class MockCatalogGateway implements DemoCatalogGateway {
  final MockApiService _legacyService = MockApiService();

  @override
  Future<List<Product>> fetchProducts(
    PaginationRequest request, {
    bool simulateError = false,
  }) =>
      MockApiService.fetchProducts(request, simulateError: simulateError);

  @override
  Future<List<Product>> fetchProductsWithError(PaginationRequest request) =>
      _legacyService.fetchProductsWithError(request);

  @override
  Future<List<Product>> searchProducts(
    String query, {
    int pageSize = 20,
  }) =>
      MockApiService.searchProducts(query, pageSize: pageSize);

  @override
  Stream<List<Product>> productsStream(PaginationRequest request) =>
      MockApiService.productsStream(request);

  @override
  Stream<List<Product>> regularProductsStream(PaginationRequest request) =>
      MockApiService.regularProductsStream(request);

  @override
  Stream<List<Product>> featuredProductsStream(PaginationRequest request) =>
      MockApiService.featuredProductsStream(request);

  @override
  Stream<List<Product>> saleProductsStream(PaginationRequest request) =>
      MockApiService.saleProductsStream(request);

  @override
  Stream<List<Product>> accumulatingProductsStream(PaginationRequest request) =>
      MockApiService.accumulatingProductsStream(request);

  @override
  Stream<List<Product>> unreliablePageStream(PaginationRequest request) =>
      MockApiService.unreliablePageStream(request);
}
