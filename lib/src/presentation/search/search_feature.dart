/// Flutter presentation module for smart search.
///
/// MVC mapping:
/// - Model: search and overlay configurations.
/// - Controllers: single and multi-selection search controllers.
/// - Views: search boxes, overlays, dropdowns, themes, and positioning helpers.
library;

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:super_pagination/data/data.dart';

import '../../application/contracts/pagination_provider.dart';
import '../../application/contracts/retry_config.dart';
import '../../domain/models/pagination_request.dart';
import '../pagination/pagination_feature.dart';

part 'models/search_config.dart';
part 'controllers/smart_search_controller.dart';
part 'controllers/smart_search_multi_controller.dart';
part 'views/theme/smart_search_theme.dart';
part 'views/utils/overlay_positioner.dart';
part 'views/widgets/smart_search_box.dart';
part 'views/widgets/smart_search_overlay.dart';
part 'views/widgets/smart_search_dropdown.dart';
part 'views/widgets/smart_search_multi_dropdown.dart';
