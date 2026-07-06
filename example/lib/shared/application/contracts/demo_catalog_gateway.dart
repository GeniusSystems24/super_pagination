import 'package:super_pagination/super_pagination.dart';
import 'package:super_pagination_example/shared/domain/entities/product.dart';

/// Application-facing contract used by example controllers and views.
///
/// Implementations may use generated data, REST, Firestore, or any other data
/// source without changing the presentation examples.
abstract interface class DemoCatalogGateway {
  Future<List<Product>> fetchProducts(
    SuperPaginationRequest request, {
    bool simulateError = false,
  });

  Future<List<Product>> fetchProductsWithError(SuperPaginationRequest request);

  Future<List<Product>> searchProducts(
    String query, {
    int pageSize = 20,
  });

  Stream<List<Product>> productsStream(SuperPaginationRequest request);

  Stream<List<Product>> regularProductsStream(SuperPaginationRequest request);

  Stream<List<Product>> featuredProductsStream(SuperPaginationRequest request);

  Stream<List<Product>> saleProductsStream(SuperPaginationRequest request);

  Stream<List<Product>> accumulatingProductsStream(SuperPaginationRequest request);

  Stream<List<Product>> unreliablePageStream(SuperPaginationRequest request);
}
