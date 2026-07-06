/// Configuration for retry behavior.
///
/// Defines how pagination should retry failed requests with exponential backoff.
///
/// Example:
/// ```dart
/// final retryConfig = RetryConfig(
///   maxAttempts: 3,
///   initialDelay: Duration(seconds: 1),
///   maxDelay: Duration(seconds: 10),
///   timeoutDuration: Duration(seconds: 30),
/// );
/// ```
class RetryConfig {
  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 10),
    this.timeoutDuration = const Duration(seconds: 30),
    this.shouldRetry,
  }) : assert(maxAttempts > 0, 'maxAttempts must be greater than 0');

  /// Maximum number of retry attempts before giving up.
  final int maxAttempts;

  /// Initial delay before the first retry.
  final Duration initialDelay;

  /// Maximum delay between retries (for exponential backoff).
  final Duration maxDelay;

  /// Timeout duration for each request attempt.
  final Duration timeoutDuration;

  /// Optional callback to determine if a specific error should trigger a retry.
  ///
  /// If null, all errors will trigger a retry (up to maxAttempts).
  /// Return true to retry, false to fail immediately.
  final bool Function(Exception error)? shouldRetry;

  /// Calculates the delay for a specific attempt using exponential backoff.
  ///
  /// Formula: min(initialDelay * 2^attempt, maxDelay)
  Duration delayForAttempt(int attempt) {
    final exponentialDelay = initialDelay * (1 << attempt);
    return exponentialDelay > maxDelay ? maxDelay : exponentialDelay;
  }

  /// Creates a copy with updated values.
  RetryConfig copyWith({
    int? maxAttempts,
    Duration? initialDelay,
    Duration? maxDelay,
    Duration? timeoutDuration,
    bool Function(Exception error)? shouldRetry,
  }) {
    return RetryConfig(
      maxAttempts: maxAttempts ?? this.maxAttempts,
      initialDelay: initialDelay ?? this.initialDelay,
      maxDelay: maxDelay ?? this.maxDelay,
      timeoutDuration: timeoutDuration ?? this.timeoutDuration,
      shouldRetry: shouldRetry ?? this.shouldRetry,
    );
  }
}
