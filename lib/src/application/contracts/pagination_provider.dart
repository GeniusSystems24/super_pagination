
import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../domain/models/pagination_request.dart';
import '../../domain/models/pagination_result.dart';

typedef WhereChecker<T> = bool Function(T item);
typedef CompareBy<T> = int Function(T a, T b);
typedef OnInsertionCallback<T> = void Function(List<T> items);

/// Unified pagination datasource contract.
///
/// Provider callbacks receive the active widget [BuildContext] together
/// with the pagination request. This allows implementations to resolve
/// dependencies from the widget tree, for example `context.read<Api>()`.
///
/// v5 exposes six canonical datasource shapes:
///
/// 1. [SuperPaginationProvider.listFuture]
/// 2. [SuperPaginationProvider.listStream]
/// 3. [SuperPaginationProvider.pageFuture]
/// 4. [SuperPaginationProvider.pageStream]
/// 5. [SuperPaginationProvider.cursorFuture]
/// 6. [SuperPaginationProvider.cursorStream]
///
/// Raw-list sources preserve the v4 item-count end heuristic. Page/cursor
/// result sources use the backend's explicit `hasMore` value.
sealed class SuperPaginationProvider<T, R extends SuperPaginationRequest> {
  const SuperPaginationProvider();

  /// Future datasource returning only page items.
  const factory SuperPaginationProvider.listFuture(
    Future<List<T>> Function(BuildContext context, R request) dataProvider,
  ) = FutureSuperPaginationProvider<T, R>;

  /// Stream datasource returning only page items.
  const factory SuperPaginationProvider.listStream(
    Stream<List<T>> Function(BuildContext context, R request) streamProvider,
  ) = StreamSuperPaginationProvider<T, R>;

  /// Future datasource returning page-aware result data.
  const factory SuperPaginationProvider.pageFuture(
    Future<PagePaginationResult<T>> Function(BuildContext context, R request) dataProvider,
  ) = FuturePageSuperPaginationProvider<T, R>;

  /// Stream datasource returning page-aware result data.
  const factory SuperPaginationProvider.pageStream(
    Stream<PagePaginationResult<T>> Function(BuildContext context, R request) streamProvider,
  ) = StreamPageSuperPaginationProvider<T, R>;

  /// Future datasource returning cursor-aware result data.
  ///
  /// Use with [SuperCursorPaginationRequest].
  const factory SuperPaginationProvider.cursorFuture(
    Future<CursorPaginationResult<T>> Function(BuildContext context, R request) dataProvider,
  ) = FutureCursorSuperPaginationProvider<T, R>;

  /// Stream datasource returning cursor-aware result data.
  ///
  /// Use with [SuperCursorPaginationRequest].
  const factory SuperPaginationProvider.cursorStream(
    Stream<CursorPaginationResult<T>> Function(BuildContext context, R request) streamProvider,
  ) = StreamCursorSuperPaginationProvider<T, R>;

  /// v4 compatibility alias for [listFuture].
  @Deprecated('Use SuperPaginationProvider.listFuture in v5.')
  const factory SuperPaginationProvider.future(
    Future<List<T>> Function(BuildContext context, R request) dataProvider,
  ) = FutureSuperPaginationProvider<T, R>;

  /// v4 compatibility alias for [listStream].
  @Deprecated('Use SuperPaginationProvider.listStream in v5.')
  const factory SuperPaginationProvider.stream(
    Stream<List<T>> Function(BuildContext context, R request) streamProvider,
  ) = StreamSuperPaginationProvider<T, R>;

  /// Compatibility utility that merges multiple raw-list streams.
  ///
  /// This remains available in v5 in addition to the six canonical datasource
  /// modes above.
  factory SuperPaginationProvider.mergeStreams(
    List<Stream<List<T>>> Function(BuildContext context, R request) streamsProvider,
  ) = MergedStreamSuperPaginationProvider<T, R>;
}

/// Future raw-list datasource.
final class FutureSuperPaginationProvider<T, R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  const FutureSuperPaginationProvider(this.dataProvider);

  final Future<List<T>> Function(BuildContext context, R request) dataProvider;
}

/// Stream raw-list datasource.
final class StreamSuperPaginationProvider<T, R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  const StreamSuperPaginationProvider(this.streamProvider);

  final Stream<List<T>> Function(BuildContext context, R request) streamProvider;
}

/// Future page-result datasource.
final class FuturePageSuperPaginationProvider<T,
        R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  const FuturePageSuperPaginationProvider(this.dataProvider);

  final Future<PagePaginationResult<T>> Function(BuildContext context, R request) dataProvider;
}

/// Stream page-result datasource.
final class StreamPageSuperPaginationProvider<T,
        R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  const StreamPageSuperPaginationProvider(this.streamProvider);

  final Stream<PagePaginationResult<T>> Function(BuildContext context, R request) streamProvider;
}

/// Future cursor-result datasource.
final class FutureCursorSuperPaginationProvider<T,
        R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  const FutureCursorSuperPaginationProvider(this.dataProvider);

  final Future<CursorPaginationResult<T>> Function(BuildContext context, R request) dataProvider;
}

/// Stream cursor-result datasource.
final class StreamCursorSuperPaginationProvider<T,
        R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  const StreamCursorSuperPaginationProvider(this.streamProvider);

  final Stream<CursorPaginationResult<T>> Function(BuildContext context, R request) streamProvider;
}

class _UnavailableMergedProviderBuildContext implements BuildContext {
  const _UnavailableMergedProviderBuildContext();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw StateError(
      'No BuildContext was supplied to getMergedStream. Pass context: ... '
      'when the streamsProvider needs inherited widget-tree values.',
    );
  }
}

/// Merged raw-list streams datasource retained for compatibility.
final class MergedStreamSuperPaginationProvider<T,
        R extends SuperPaginationRequest>
    extends SuperPaginationProvider<T, R> {
  MergedStreamSuperPaginationProvider(this.streamsProvider);

  final List<Stream<List<T>>> Function(BuildContext context, R request) streamsProvider;

  Stream<List<T>> getMergedStream(R request, {BuildContext? context}) {
    final effectiveContext =
        context ?? const _UnavailableMergedProviderBuildContext();
    final streams = streamsProvider(effectiveContext, request);

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

/// Legacy typedef retained for source compatibility.
typedef PaginationDataProvider<T> =
    Future<List<T>> Function(BuildContext context, SuperPaginationRequest request);

/// Legacy typedef retained for source compatibility.
typedef PaginationStreamProvider<T> =
    Stream<List<T>> Function(BuildContext context, SuperPaginationRequest request);

/// Signature for a function that builds a list from fetched items.
typedef ListBuilder<T> = List<T> Function(List<T> list);

/// Signature for a callback called when items are inserted.
typedef InsertAllCallback<T> =
    void Function(List<T> currentItems, Iterable<T> newItems);
