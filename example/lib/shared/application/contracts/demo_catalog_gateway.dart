import 'package:super_pagination/super_pagination.dart';
import 'package:super_pagination_example/shared/domain/entities/product.dart';

/// Application-facing contract used by example controllers and views.
///
/// Implementations may use generated data, REST, Firestore, or any other data
/// source without changing the presentation examples.
abstract interface class DemoCatalogGateway {
  Future<List<Product>> fetchProducts(
    PaginationRequest request, {
    bool simulateError = false,
  });

  Future<List<Product>> fetchProductsWithError(PaginationRequest request);

  Future<List<Product>> searchProducts(
    String query, {
    int pageSize = 20,
  });

  Stream<List<Product>> productsStream(PaginationRequest request);

  Stream<List<Product>> regularProductsStream(PaginationRequest request);

  Stream<List<Product>> featuredProductsStream(PaginationRequest request);

  Stream<List<Product>> saleProductsStream(PaginationRequest request);

  Stream<List<Product>> accumulatingProductsStream(PaginationRequest request);

  Stream<List<Product>> unreliablePageStream(PaginationRequest request);
}
