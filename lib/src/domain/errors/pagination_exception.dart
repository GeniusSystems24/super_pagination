/// Custom exception types for pagination errors.
///
/// Provides more specific error information than generic Exception.
abstract class PaginationException implements Exception {
  const PaginationException(this.message, {this.originalError, this.stackTrace});

  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  @override
  String toString() {
    if (originalError != null) {
      return '$runtimeType: $message\nOriginal error: $originalError';
    }
    return '$runtimeType: $message';
  }
}

/// Exception thrown when a network request times out.
class PaginationTimeoutException extends PaginationException {
  const PaginationTimeoutException({
    String message = 'Request timed out',
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError: originalError, stackTrace: stackTrace);
}

/// Exception thrown when a network request fails.
class PaginationNetworkException extends PaginationException {
  const PaginationNetworkException({
    String message = 'Network request failed',
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError: originalError, stackTrace: stackTrace);
}

/// Exception thrown when data parsing fails.
class PaginationParseException extends PaginationException {
  const PaginationParseException({
    String message = 'Failed to parse data',
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError: originalError, stackTrace: stackTrace);
}

/// Exception thrown when all retry attempts have been exhausted.
class PaginationRetryExhaustedException extends PaginationException {
  const PaginationRetryExhaustedException({
    required this.attempts,
    String message = 'All retry attempts exhausted',
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError: originalError, stackTrace: stackTrace);

  /// The number of attempts that were made.
  final int attempts;

  @override
  String toString() {
    return 'PaginationRetryExhaustedException: $message after $attempts attempts\n'
        'Original error: $originalError';
  }
}
