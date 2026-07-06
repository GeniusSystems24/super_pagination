import 'dart:async';

import '../../domain/models/pagination_request.dart';

typedef WhereChecker<T> = bool Function(T item);
typedef CompareBy<T> = int Function(T a, T b);
typedef OnInsertionCallback<T> = void Function(List<T> items);

/// Unified pagination data provider that can be either Future-based or Stream-based.
///
/// The second type parameter [R] is the concrete [SuperPaginationRequest] type
/// (or subclass) that the provider callback will receive. This enables
/// compile-time type safety when passing custom request objects.
///
/// Use [SuperPaginationProvider.future] for standard REST API pagination.
/// Use [SuperPaginationProvider.stream] for real-time updates.
///
/// Example with the base request type (no custom fields):
/// ```dart
/// final provider = SuperPaginationProvider<Product, SuperPaginationRequest>.future(
///   (request) => apiService.fetchProducts(request),
/// );
/// // Shorthand – SuperPaginationRequest is the default bound:
/// final provider = SuperPaginationProvider<Product>.future(
///   (request) => apiService.fetchProducts(request),
/// );
/// ```
///
/// Example with a custom typed request:
/// ```dart
/// final provider = SuperPaginationProvider<Product, ProductRequest>.future(
///   (req) => apiService.fetchProducts(req.category, maxPrice: req.maxPrice),
/// );
/// ```
///
/// Example with Stream:
/// ```dart
/// final provider = SuperPaginationProvider<Product, ProductRequest>.stream(
///   (req) => apiService.productsStream(req.category),
/// );
/// ```
sealed class SuperPaginationProvider<T, R extends SuperPaginationRequest> {
  const SuperPaginationProvider();

  /// Creates a Future-based pagination provider for standard REST APIs.
  const factory SuperPaginationProvider.future(
    Future<List<T>> Function(R request) dataProvider,
  ) = FutureSuperPaginationProvider<T, R>;

  /// Creates a Stream-based pagination provider for real-time updates.
  const factory SuperPaginationProvider.stream(
    Stream<List<T>> Function(R request) streamProvider,
  ) = StreamSuperPaginationProvider<T, R>;

  /// Creates a provider that merges multiple streams into a single stream.
  ///
  /// When you have multiple data sources (streams) and want to combine them
  /// into one unified stream, use this provider.
  ///
  /// Example:
  /// ```dart
  /// final provider = SuperPaginationProvider<Product, ProductRequest>.mergeStreams(
  ///   (req) => [
  ///     apiService.regularProductsStream(req),
  ///     apiService.featuredProductsStream(req),
  ///   ],
  /// );
  /// ```
  factory SuperPaginationProvider.mergeStreams(
    List<Stream<List<T>>> Function(R request) streamsProvider,
  ) = MergedStreamSuperPaginationProvider<T, R>;
}

/// Future-based pagination provider for standard REST APIs.
final class FutureSuperPaginationProvider<T, R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  const FutureSuperPaginationProvider(this.dataProvider);

  /// Function that fetches a page of data from your API.
  final Future<List<T>> Function(R request) dataProvider;
}

/// Stream-based pagination provider for real-time updates.
final class StreamSuperPaginationProvider<T, R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  const StreamSuperPaginationProvider(this.streamProvider);

  /// Function that provides a stream of data updates.
  final Stream<List<T>> Function(R request) streamProvider;
}

/// Merged streams pagination provider that combines multiple streams into one.
///
/// This provider takes multiple data streams and merges them into a single
/// stream, emitting data whenever any of the source streams emit.
final class MergedStreamSuperPaginationProvider<T, R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  MergedStreamSuperPaginationProvider(this.streamsProvider);

  /// Function that provides a list of streams to be merged.
  final List<Stream<List<T>>> Function(R request) streamsProvider;

  /// Gets a merged stream that combines all source streams.
  ///
  /// Lifecycle contract (spec 002-stabilize-provider §FR-020 to FR-023):
  ///
  /// - **Zero streams**: returns `Stream.value([])` which owns no
  ///   subscription and no controller; nothing to leak.
  /// - **One or more streams**: wraps every child subscription in an
  ///   internal `StreamController` whose `onCancel` cancels every child
  ///   subscription and whose internal `completed` counter closes the
  ///   controller only when **every** child has completed. The single-stream
  ///   case uses the same wrapper as the multi-stream case so cancellation
  ///   is symmetric (previously the single branch returned the underlying
  ///   stream directly, leaking the subscription if the consumer never
  ///   cancelled via the merge provider).
  Stream<List<T>> getMergedStream(R request) {
    final streams = streamsProvider(request);

    if (streams.isEmpty) {
      return Stream.value(<T>[]);
    }

    late StreamController<List<T>> controller;
    final subscriptions = <StreamSubscription<List<T>>>[];
    var completed = 0;

    void maybeClose() {
      if (completed == streams.length && !controller.isClosed) {
        controller.close();
      }
    }

    controller = StreamController<List<T>>(
      onListen: () {
        for (final stream in streams) {
          final subscription = stream.listen(
            controller.add,
            onError: controller.addError,
            onDone: () {
              completed++;
              maybeClose();
            },
          );
          subscriptions.add(subscription);
        }
      },
      onCancel: () async {
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
      },
    );

    return controller.stream;
  }
}

/// Legacy typedef for backward compatibility (will be deprecated).
typedef PaginationDataProvider<T> =
    Future<List<T>> Function(SuperPaginationRequest request);

/// Legacy typedef for backward compatibility (will be deprecated).
typedef PaginationStreamProvider<T> =
    Stream<List<T>> Function(SuperPaginationRequest request);

/// Signature for a function that builds a list from fetched items.
typedef ListBuilder<T> = List<T> Function(List<T> list);

/// Signature for a callback function that is called when items are inserted.
typedef InsertAllCallback<T> =
    void Function(List<T> currentItems, Iterable<T> newItems);