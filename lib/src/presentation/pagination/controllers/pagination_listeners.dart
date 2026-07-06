part of '../pagination_feature.dart';

class SuperPaginationChangeListener extends ChangeNotifier
    implements IPaginationChangeListener {}

class SuperPaginationRefreshedChangeListener
    extends SuperPaginationChangeListener
    implements IPaginationRefreshedChangeListener {
  SuperPaginationRefreshedChangeListener();

  bool _refreshed = false;

  @override
  set refreshed(bool value) {
    _refreshed = value;
    if (value) {
      notifyListeners();
    }
  }

  @override
  bool get refreshed {
    return _refreshed;
  }
}

class SuperPaginationFilterChangeListener<T>
    extends SuperPaginationChangeListener
    implements IPaginationFilterChangeListener<T> {
  SuperPaginationFilterChangeListener();

  WhereChecker<T>? _filterChecker;

  @override
  set searchTerm(WhereChecker<T>? value) {
    if (value == _filterChecker) return;
    _filterChecker = value;
    notifyListeners();
  }

  @override
  WhereChecker<T>? get searchTerm {
    return _filterChecker;
  }
}

class SuperPaginationOrderChangeListener<T>
    extends SuperPaginationChangeListener
    implements IPaginationOrderChangeListener<T> {
  SuperPaginationOrderChangeListener();

  CompareBy<T>? _orderBy;

  @override
  set orderCompare(CompareBy<T>? value) {
    if (value == _orderBy) return;
    _orderBy = value;
    notifyListeners();
  }

  @override
  CompareBy<T>? get orderCompare => _orderBy;
}
