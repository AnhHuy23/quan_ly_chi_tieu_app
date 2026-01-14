/// Base Exception cho ứng dụng
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => 'AppException($code): $message';
}

/// Exception khi khởi tạo database thất bại
class DatabaseInitException extends AppException {
  const DatabaseInitException({
    super.message = 'Không thể khởi tạo database',
    super.code = 'DB_INIT_FAILED',
    super.originalError,
  });
}

/// Exception khi không tìm thấy dữ liệu
class DataNotFoundException extends AppException {
  const DataNotFoundException({
    required String entityName,
    String? id,
    super.originalError,
  }) : super(
         message: id != null
             ? 'Không tìm thấy $entityName với ID: $id'
             : 'Không tìm thấy $entityName',
         code: 'NOT_FOUND',
       );
}

/// Exception khi validation thất bại
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_FAILED',
    super.originalError,
  });
}

/// Exception cho lỗi database chung
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code = 'DB_ERROR',
    super.originalError,
  });
}
