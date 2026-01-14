import 'package:flutter/material.dart';
import '../datasources/local_database.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';

/// Transaction Repository - Provider cho UI
/// Quản lý state và business logic cho transactions & categories
class TransactionRepository extends ChangeNotifier {
  /// Dependency injection cho database (dễ test)
  final LocalDatabase _db;

  TransactionRepository({LocalDatabase? database})
    : _db = database ?? LocalDatabase();

  List<TransactionModel> _transactions = [];
  List<CategoryModel> _categories = [];

  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = false;

  // === CACHED VALUES (tránh query DB liên tục) ===
  double _cachedTotalIncome = 0;
  double _cachedTotalExpense = 0;
  double _cachedTotalBalance = 0;
  bool _isStatisticsDirty = true;

  // Getters
  List<TransactionModel> get transactions => _transactions;
  List<CategoryModel> get categories => _categories;
  DateTime get selectedMonth => _selectedMonth;
  bool get isLoading => _isLoading;

  /// Danh mục chi tiêu
  List<CategoryModel> get expenseCategories =>
      _categories.where((c) => c.isExpense).toList();

  /// Danh mục thu nhập
  List<CategoryModel> get incomeCategories =>
      _categories.where((c) => !c.isExpense).toList();

  /// Tổng thu nhập tháng hiện tại (CACHED)
  double get totalIncome {
    _ensureStatisticsComputed();
    return _cachedTotalIncome;
  }

  /// Tổng chi tiêu tháng hiện tại (CACHED)
  double get totalExpense {
    _ensureStatisticsComputed();
    return _cachedTotalExpense;
  }

  /// Số dư tháng hiện tại
  double get balance => totalIncome - totalExpense;

  /// Số dư tổng (all time) - CACHED
  double get totalBalance {
    _ensureStatisticsComputed();
    return _cachedTotalBalance;
  }

  /// Giao dịch group theo ngày
  Map<DateTime, List<TransactionModel>> get transactionsByDate {
    final result = <DateTime, List<TransactionModel>>{};
    for (final t in _transactions) {
      final dateKey = DateTime(t.date.year, t.date.month, t.date.day);
      result.putIfAbsent(dateKey, () => []).add(t);
    }
    return result;
  }

  /// Tính toán thống kê nếu cache đã dirty
  void _ensureStatisticsComputed() {
    if (!_isStatisticsDirty) return;

    _cachedTotalIncome = _transactions
        .where((t) => !t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
    _cachedTotalExpense = _transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
    _cachedTotalBalance = _db.getBalance();

    _isStatisticsDirty = false;
  }

  /// Đánh dấu cache cần tính lại
  void _invalidateCache() {
    _isStatisticsDirty = true;
  }

  /// Khởi tạo repository
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _db.init();
    await _loadData();

    _isLoading = false;
    notifyListeners();
  }

  /// Load data từ database
  Future<void> _loadData() async {
    _categories = _db.getAllCategories();
    _transactions = _db.getTransactionsByMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    _invalidateCache();
  }

  /// Reload transactions
  Future<void> reload() async {
    _transactions = _db.getTransactionsByMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    _invalidateCache();
    notifyListeners();
  }

  /// Thay đổi tháng
  void changeMonth(DateTime month) {
    _selectedMonth = month;
    _transactions = _db.getTransactionsByMonth(month.year, month.month);
    _invalidateCache();
    notifyListeners();
  }

  /// Tháng trước
  void previousMonth() {
    changeMonth(DateTime(_selectedMonth.year, _selectedMonth.month - 1));
  }

  /// Tháng sau
  void nextMonth() {
    changeMonth(DateTime(_selectedMonth.year, _selectedMonth.month + 1));
  }

  // ============ TRANSACTION CRUD ============

  /// Thêm giao dịch mới
  Future<void> addTransaction({
    required double amount,
    required String categoryId,
    required String note,
    required DateTime date,
    required bool isExpense,
  }) async {
    await _db.addTransaction(
      amount: amount,
      categoryId: categoryId,
      note: note,
      date: date,
      isExpense: isExpense,
    );
    await reload();
  }

  /// Cập nhật giao dịch
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _db.updateTransaction(transaction);
    await reload();
  }

  /// Xóa giao dịch
  Future<void> deleteTransaction(String id) async {
    await _db.deleteTransaction(id);
    await reload();
  }

  /// Lấy category theo ID
  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // ============ STATISTICS ============

  /// Thống kê chi tiêu theo danh mục
  Map<CategoryModel, double> getExpenseByCategory() {
    final data = _db.getExpenseByCategory(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    final result = <CategoryModel, double>{};

    for (final entry in data.entries) {
      final category = getCategoryById(entry.key);
      if (category != null) {
        result[category] = entry.value;
      }
    }
    return result;
  }

  /// Thống kê chi tiêu theo ngày
  Map<int, double> getDailyExpense() {
    return _db.getDailyExpenseByMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );
  }

  // ============ CATEGORY CRUD ============

  /// Thêm danh mục
  Future<void> addCategory({
    required String name,
    required int iconCode,
    required int colorValue,
    required bool isExpense,
  }) async {
    await _db.addCategory(
      name: name,
      iconCode: iconCode,
      colorValue: colorValue,
      isExpense: isExpense,
    );
    _categories = _db.getAllCategories();
    notifyListeners();
  }

  /// Xóa danh mục
  Future<void> deleteCategory(String id) async {
    await _db.deleteCategory(id);
    _categories = _db.getAllCategories();
    notifyListeners();
  }

  /// Cleanup resources
  @override
  void dispose() {
    _db.close();
    super.dispose();
  }
}
