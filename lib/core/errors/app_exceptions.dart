import '../models/api_response.dart';

abstract class AppException implements Exception {
  final String message;
  final ApiErrorType errorType;

  const AppException(this.message, this.errorType);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([String? message])
      : super(
          message ?? 'No internet connection',
          ApiErrorType.network,
        );
}

class ApiException extends AppException {
  final int? statusCode;

  const ApiException(String message, {this.statusCode})
      : super(message, ApiErrorType.api);
}

class RateLimitException extends AppException {
  const RateLimitException()
      : super(
          'Rate limit reached. Please try again later.',
          ApiErrorType.rateLimit,
        );
}

class InvalidApiKeyException extends AppException {
  const InvalidApiKeyException()
      : super(
          'Invalid API key. Please check your configuration.',
          ApiErrorType.invalidApiKey,
        );
}

class CacheException extends AppException {
  const CacheException([String? message])
      : super(
          message ?? 'Cache error occurred',
          ApiErrorType.cache,
        );
}

class UnknownException extends AppException {
  const UnknownException([String? message])
      : super(
          message ?? 'An unknown error occurred',
          ApiErrorType.unknown,
        );
}
