import '../application/contracts/pagination_provider.dart';
import '../domain/models/pagination_meta.dart';
import '../domain/models/pagination_request.dart';
import '../presentation/pagination/pagination_feature.dart';

/// Canonical v4 name for the pagination widget.
///
/// The former `SmartPagination` name remains available for source
/// compatibility. A type alias is used so every existing constructor and
/// generic constraint keeps exactly the same behavior.
typedef SuperPagination<T, R extends PaginationRequest>
    = SmartPagination<T, R>;

typedef SuperPaginationCubit<T, R extends PaginationRequest>
    = SmartPaginationCubit<T, R>;
typedef SuperPaginationController<T, R extends PaginationRequest>
    = SmartPaginationController<T, R>;

typedef SuperPaginationState<T> = SmartPaginationState<T>;
typedef SuperPaginationInitial<T> = SmartPaginationInitial<T>;
typedef SuperPaginationLoaded<T> = SmartPaginationLoaded<T>;
typedef SuperPaginationError<T> = SmartPaginationError<T>;

typedef SuperPaginationChangeListener = SmartPaginationChangeListener;
typedef SuperPaginationRefreshedChangeListener
    = SmartPaginationRefreshedChangeListener;
typedef SuperPaginationFilterChangeListener<T>
    = SmartPaginationFilterChangeListener<T>;
typedef SuperPaginationOrderChangeListener<T>
    = SmartPaginationOrderChangeListener<T>;

typedef SuperPaginationListView<T, R extends PaginationRequest>
    = SmartPaginationListView<T, R>;
typedef SuperPaginationGridView<T, R extends PaginationRequest>
    = SmartPaginationGridView<T, R>;
typedef SuperPaginationColumn<T, R extends PaginationRequest>
    = SmartPaginationColumn<T, R>;
typedef SuperPaginationRow<T, R extends PaginationRequest>
    = SmartPaginationRow<T, R>;
typedef SuperPaginationPageView<T, R extends PaginationRequest>
    = SmartPaginationPageView<T, R>;
typedef SuperPaginationStaggeredGridView<T, R extends PaginationRequest>
    = SmartPaginationStaggeredGridView<T, R>;
typedef SuperPaginationReorderableListView<T, R extends PaginationRequest>
    = SmartPaginationReorderableListView<T, R>;

typedef SuperPaginationRequest = PaginationRequest;
typedef SuperPaginationMeta = PaginationMeta;
typedef SuperPaginationProvider<T, R extends PaginationRequest>
    = PaginationProvider<T, R>;
