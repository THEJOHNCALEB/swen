import '../errors/app_exceptions.dart';

sealed class ApiResponse<T> {
  const ApiResponse();
}

class ApiLoading<T> extends ApiResponse<T> {
  const ApiLoading();
}

class ApiSuccess<T> extends ApiResponse<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiError<T> extends ApiResponse<T> {
  final String message;
  final ApiErrorType type;
  
  const ApiError(this.message, this.type);
  
  factory ApiError.fromException(AppException exception) {
    return ApiError(
      exception.message,
      exception.errorType,
    );
  }
}

enum ApiErrorType {
  network,
  api,
  cache,
  rateLimit,
  invalidApiKey,
  unknown,
}
