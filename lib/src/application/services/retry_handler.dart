import 'dart:async';

import '../../domain/errors/pagination_exception.dart';
import '../contracts/retry_config.dart';

/// Utility class for executing functions with retry and timeout logic.
class RetryHandler {
  const RetryHandler(this.config);

  final RetryConfig config;

  /// Executes a function with retry and timeout logic.
  ///
  /// Returns the result if successful, throws an exception if all retries fail.
  ///
  /// Example:
  /// ```dart
  /// final handler = RetryHandler(RetryConfig(maxAttempts: 3));
  ///
  /// final data = await handler.execute(
  ///   () => fetchData(),
  ///   onRetry: (attempt, error) {
  ///     print('Retry attempt $attempt after error: $error');
  ///   },
  /// );
  /// ```
  Future<T> execute<T>(
    Future<T> Function() function, {
    void Function(int attempt, Exception error)? onRetry,
  }) async {
    Exception? lastError;

    for (int attempt = 0; attempt < config.maxAttempts; attempt++) {
      try {
        // Add timeout to the function
        final result = await function().timeout(
          config.timeoutDuration,
          onTimeout: () {
            throw TimeoutException(
              'Request timed out after ${config.timeoutDuration.inSeconds} seconds',
            );
          },
        );

        return result;
      } on TimeoutException catch (e, stack) {
        lastError = PaginationTimeoutException(
          message: e.message ?? 'Request timed out',
          originalError: e,
          stackTrace: stack,
        );
      } on PaginationException catch (e) {
        lastError = e;
      } catch (e, stack) {
        // Wrap unknown errors
        lastError = PaginationNetworkException(
          message: 'Unexpected error: ${e.toString()}',
          originalError: e,
          stackTrace: stack,
        );
      }

      // Check if we should retry
      final shouldRetry = config.shouldRetry?.call(lastError) ?? true;

      if (!shouldRetry || attempt == config.maxAttempts - 1) {
        // Don't retry or this was the last attempt
        break;
      }

      // Notify about retry
      onRetry?.call(attempt + 1, lastError);

      // Wait before retrying
      final delay = config.delayForAttempt(attempt);
      await Future.delayed(delay);
    }

    // All retries exhausted
    throw PaginationRetryExhaustedException(
      attempts: config.maxAttempts,
      message: 'Failed after ${config.maxAttempts} attempts',
      originalError: lastError,
      // stackTrace: lastError?.stackTrace,
    );
  }
}
