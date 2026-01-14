import '../entities/transaction_entity.dart';

/// Abstract Transaction Repository Interface
///
/// Định nghĩa contract cho transaction repository.
/// Data layer sẽ implement interface này.
abstract class ITransactionRepository {
  /// Lấy giao dịch theo tháng
  Future<List<TransactionEntity>> getByMonth(int year, int month);

  /// Lấy giao dịch theo khoảng thời gian
  Future<List<TransactionEntity>> getByDateRange(DateTime start, DateTime end);

  /// Lấy tất cả giao dịch
  Future<List<TransactionEntity>> getAll();

  /// Lấy giao dịch theo ID
  Future<TransactionEntity?> getById(String id);

  /// Thêm giao dịch mới
  Future<TransactionEntity> add({
    required double amount,
    required String categoryId,
    required String note,
    required DateTime date,
    required bool isExpense,
  });

  /// Cập nhật giao dịch
  Future<void> update(TransactionEntity transaction);

  /// Xóa giao dịch
  Future<void> delete(String id);

  /// Tính tổng thu nhập theo tháng
  double getTotalIncomeByMonth(int year, int month);

  /// Tính tổng chi tiêu theo tháng
  double getTotalExpenseByMonth(int year, int month);

  /// Tính số dư tổng (all time)
  double getBalance();

  /// Thống kê chi tiêu theo danh mục trong tháng
  Map<String, double> getExpenseByCategory(int year, int month);

  /// Thống kê chi tiêu theo ngày trong tháng
  Map<int, double> getDailyExpenseByMonth(int year, int month);
}
