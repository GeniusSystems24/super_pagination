import 'package:flutter/foundation.dart';
import 'package:super_pagination_example/features/firebase_examples/application/contracts/seed_data_gateway.dart';

@immutable
final class SeedOperationResult {
  const SeedOperationResult.success(this.message) : isSuccess = true;

  const SeedOperationResult.failure(this.message) : isSuccess = false;

  final bool isSuccess;
  final String message;
}

/// Coordinates seed operations and exposes immutable state to the view.
final class SeedDataController extends ChangeNotifier {
  SeedDataController(this._gateway);

  final SeedDataGateway _gateway;
  final List<String> _logs = [];

  bool _isLoading = false;
  String? _currentAction;

  bool get isLoading => _isLoading;
  String? get currentAction => _currentAction;
  List<String> get logs => List.unmodifiable(_logs);

  Future<SeedOperationResult> seedAllData() => _execute(
        action: 'Seeding all data...',
        successMessage: '✅ All data seeded successfully!',
        operation: _gateway.seedAllData,
        clearLogs: true,
      );

  Future<SeedOperationResult> seedProducts() => _execute(
        action: 'Seeding products...',
        successMessage: '✅ Products seeded!',
        operation: _gateway.seedProducts,
      );

  Future<SeedOperationResult> seedUsers() => _execute(
        action: 'Seeding users...',
        successMessage: '✅ Users seeded!',
        operation: _gateway.seedUsers,
      );

  Future<SeedOperationResult> seedMessages() => _execute(
        action: 'Seeding messages...',
        successMessage: '✅ Messages seeded!',
        operation: _gateway.seedMessages,
      );

  Future<SeedOperationResult> seedPosts() => _execute(
        action: 'Seeding posts...',
        successMessage: '✅ Posts seeded!',
        operation: _gateway.seedPosts,
      );

  Future<SeedOperationResult> clearAllData() => _execute(
        action: 'Clearing all data...',
        successMessage: '✅ All data cleared!',
        operation: _gateway.clearAllData,
        clearLogs: true,
      );

  void clearLogs() {
    if (_logs.isEmpty) return;
    _logs.clear();
    notifyListeners();
  }

  Future<SeedOperationResult> _execute({
    required String action,
    required String successMessage,
    required Future<void> Function({void Function(String message)? onProgress})
        operation,
    bool clearLogs = false,
  }) async {
    if (_isLoading) {
      return const SeedOperationResult.failure('Another operation is running.');
    }

    _isLoading = true;
    _currentAction = action;
    if (clearLogs) _logs.clear();
    notifyListeners();

    try {
      await operation(onProgress: _addLog);
      return SeedOperationResult.success(successMessage);
    } catch (error) {
      final message = 'Error: $error';
      _addLog('❌ $message');
      return SeedOperationResult.failure(message);
    } finally {
      _isLoading = false;
      _currentAction = null;
      notifyListeners();
    }
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().split('.').first;
    _logs.add('[$timestamp] $message');
    notifyListeners();
  }
}
