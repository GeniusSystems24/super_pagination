/// Flutter presentation module for pagination.
///
/// MVC mapping:
/// - Model: [SuperPaginationState] and its concrete states.
/// - Controllers: [SuperPaginationCubit] and [SuperPaginationController].
/// - Views: [SuperPagination] and the specialized pagination widgets.
library;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:super_core/super_core.dart';

import '../../application/contracts/pagination_listeners.dart';
import '../../application/contracts/pagination_provider.dart';
import '../../application/contracts/pagination_state.dart';
import '../../application/contracts/retry_config.dart';
import '../../application/services/retry_handler.dart';
import '../../domain/errors/pagination_exception.dart';
import '../../domain/models/pagination_meta.dart';
import '../../domain/models/pagination_request.dart';
import '../../domain/models/sort_order.dart';

export 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
export 'package:scrollview_observer/scrollview_observer.dart';

part 'models/pagination_state.dart';

part 'controllers/pagination_cubit_contract.dart';
part 'controllers/super_pagination_cubit.dart';
part 'controllers/pagination_listeners.dart';
part 'controllers/pagination_controller_contract.dart';
part 'controllers/super_pagination_controller.dart';
part 'controllers/scroll_to_message_mixin.dart';

part 'views/theme/super_pagination_theme.dart';

part 'views/super_pagination_view.dart';
part 'views/widgets/bottom_loader.dart';
part 'views/widgets/empty_display.dart';
part 'views/widgets/empty_separator.dart';
part 'views/widgets/error_display.dart';
part 'views/widgets/custom_error_builder.dart';
part 'views/widgets/initial_loader.dart';
part 'views/widgets/paginate_api_view.dart';
part 'views/widgets/super_pagination_list_view.dart';
part 'views/widgets/super_pagination_grid_view.dart';
part 'views/widgets/super_pagination_column.dart';
part 'views/widgets/super_pagination_row.dart';
part 'views/widgets/super_pagination_page_view.dart';
part 'views/widgets/super_pagination_staggered_grid_view.dart';
part 'views/widgets/super_pagination_reorderable_list_view.dart';
