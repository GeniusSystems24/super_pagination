/// SuperPagination
///
/// A modular Flutter pagination package organized using Clean Architecture,
/// SOLID boundaries, and an MVC-oriented presentation layer.
library;

export 'src/application/contracts/pagination_listeners.dart';
export 'src/application/contracts/pagination_provider.dart';
export 'src/application/contracts/pagination_state.dart';
export 'src/application/contracts/retry_config.dart';
export 'src/application/services/retry_handler.dart';
export 'src/domain/errors/pagination_exception.dart';
export 'src/domain/models/pagination_meta.dart';
export 'src/domain/models/pagination_request.dart';
export 'src/domain/models/sort_order.dart';
export 'src/presentation/pagination/pagination_feature.dart';
export 'src/presentation/search/search_feature.dart';
export 'src/public/super_pagination_aliases.dart';
