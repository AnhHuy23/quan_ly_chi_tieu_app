import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

/// Local Database Service - Quản lý Hive boxes
class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  factory LocalDatabase() => _instance;
  LocalDatabase._internal();

  static const _uuid = Uuid();

  late Box<TransactionModel> _transactionBox;
  late Box<CategoryModel> _categoryBox;

  bool _isInitialized = false;

  /// Khởi tạo Hive và các boxes
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Đăng ký adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }

    // Mở boxes
    _transactionBox = await Hive.openBox<TransactionModel>(
      AppConstants.transactionBox,
    );
    _categoryBox = await Hive.openBox<CategoryModel>(AppConstants.categoryBox);

    // Khởi tạo danh mục mặc định nếu chưa có
    await _initDefaultCategories();

    _isInitialized = true;
  }

  /// Khởi tạo danh mục mặc định
  Future<void> _initDefaultCategories() async {
    if (_categoryBox.isEmpty) {
      // Thêm danh mục chi tiêu
      for (final cat in DefaultCategories.expenseCategories) {
        final category = CategoryModel.fromMap(cat, isExpense: true);
        await _categoryBox.put(category.id, category);
      }
      // Thêm danh mục thu nhập
      for (final cat in DefaultCategories.incomeCategories) {
        final category = CategoryModel.fromMap(cat, isExpense: false);
        await _categoryBox.put(category.id, category);
      }
    }
  }

  // ============ TRANSACTION METHODS ============

  /// Lấy tất cả giao dịch
  List<TransactionModel> getAllTransactions() {
    return _transactionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Lấy giao dịch theo tháng
  List<TransactionModel> getTransactionsByMonth(int year, int month) {
    return _transactionBox.values
        .where((t) => t.date.year == year && t.date.month == month)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Lấy giao dịch theo khoảng thời gian
  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _transactionBox.values
        .where(
          (t) =>
              t.date.isAfter(start.subtract(const Duration(days: 1))) &&
              t.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Thêm giao dịch mới
  Future<TransactionModel> addTransaction({
    required double amount,
    required String categoryId,
    required String note,
    required DateTime date,
    required bool isExpense,
  }) async {
    final transaction = TransactionModel(
      id: _uuid.v4(),
      amount: amount,
      categoryId: categoryId,
      note: note,
      date: date,
      isExpense: isExpense,
    );
    await _transactionBox.put(transaction.id, transaction);
    return transaction;
  }

  /// Cập nhật giao dịch
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  /// Xóa giao dịch
  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  /// Lấy giao dịch theo ID
  TransactionModel? getTransactionById(String id) {
    return _transactionBox.get(id);
  }

  // ============ CATEGORY METHODS ============

  /// Lấy tất cả danh mục
  List<CategoryModel> getAllCategories() {
    return _categoryBox.values.toList();
  }

  /// Lấy danh mục theo loại (thu/chi)
  List<CategoryModel> getCategoriesByType({required bool isExpense}) {
    return _categoryBox.values.where((c) => c.isExpense == isExpense).toList();
  }

  /// Lấy danh mục theo ID
  CategoryModel? getCategoryById(String id) {
    return _categoryBox.get(id);
  }

  /// Thêm danh mục mới
  Future<CategoryModel> addCategory({
    required String name,
    required int iconCode,
    required int colorValue,
    required bool isExpense,
  }) async {
    final category = CategoryModel(
      id: _uuid.v4(),
      name: name,
      iconCode: iconCode,
      colorValue: colorValue,
      isExpense: isExpense,
      isCustom: true,
    );
    await _categoryBox.put(category.id, category);
    return category;
  }

  /// Cập nhật danh mục
  Future<void> updateCategory(CategoryModel category) async {
    await _categoryBox.put(category.id, category);
  }

  /// Xóa danh mục
  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  // ============ STATISTICS METHODS ============

  /// Tính tổng thu nhập theo tháng
  double getTotalIncomeByMonth(int year, int month) {
    return _transactionBox.values
        .where(
          (t) => !t.isExpense && t.date.year == year && t.date.month == month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Tính tổng chi tiêu theo tháng
  double getTotalExpenseByMonth(int year, int month) {
    return _transactionBox.values
        .where(
          (t) => t.isExpense && t.date.year == year && t.date.month == month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Tính số dư (tổng thu - tổng chi)
  double getBalance() {
    final income = _transactionBox.values
        .where((t) => !t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expense = _transactionBox.values
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
    return income - expense;
  }

  /// Thống kê chi tiêu theo danh mục trong tháng
  Map<String, double> getExpenseByCategory(int year, int month) {
    final result = <String, double>{};
    final transactions = _transactionBox.values.where(
      (t) => t.isExpense && t.date.year == year && t.date.month == month,
    );

    for (final t in transactions) {
      result[t.categoryId] = (result[t.categoryId] ?? 0) + t.amount;
    }
    return result;
  }

  /// Thống kê chi tiêu theo ngày trong tháng
  Map<int, double> getDailyExpenseByMonth(int year, int month) {
    final result = <int, double>{};
    final transactions = _transactionBox.values.where(
      (t) => t.isExpense && t.date.year == year && t.date.month == month,
    );

    for (final t in transactions) {
      result[t.date.day] = (result[t.date.day] ?? 0) + t.amount;
    }
    return result;
  }

  /// Đóng database
  Future<void> close() async {
    await _transactionBox.close();
    await _categoryBox.close();
  }
}
