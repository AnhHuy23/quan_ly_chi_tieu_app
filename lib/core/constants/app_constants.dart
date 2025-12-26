/// App Constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Quản lý chi tiêu';
  static const String appVersion = '1.0.0';

  // Hive box names
  static const String transactionBox = 'transactions';
  static const String categoryBox = 'categories';
  static const String settingsBox = 'settings';

  // Currency
  static const String currencySymbol = '₫';
  static const String currencyCode = 'VND';
  static const String locale = 'vi_VN';
}

/// Transaction Types
enum TransactionType { income, expense }

/// Default Categories
class DefaultCategories {
  DefaultCategories._();

  // Expense categories
  static const List<Map<String, dynamic>> expenseCategories = [
    {'id': 'food', 'name': 'Ăn uống', 'icon': 0xe532, 'color': 0xFFFF7675},
    {
      'id': 'transport',
      'name': 'Di chuyển',
      'icon': 0xe1d7,
      'color': 0xFF74B9FF,
    },
    {'id': 'shopping', 'name': 'Mua sắm', 'icon': 0xe59c, 'color': 0xFFFD79A8},
    {
      'id': 'entertainment',
      'name': 'Giải trí',
      'icon': 0xe40f,
      'color': 0xFFA29BFE,
    },
    {'id': 'bills', 'name': 'Hóa đơn', 'icon': 0xe873, 'color': 0xFFFDCB6E},
    {'id': 'health', 'name': 'Sức khỏe', 'icon': 0xe3f3, 'color': 0xFF55EFC4},
    {
      'id': 'education',
      'name': 'Giáo dục',
      'icon': 0xe865,
      'color': 0xFF81ECEC,
    },
    {'id': 'gift', 'name': 'Quà tặng', 'icon': 0xe8f6, 'color': 0xFFFF85A2},
    {
      'id': 'other_expense',
      'name': 'Khác',
      'icon': 0xe8fe,
      'color': 0xFFB2BEC3,
    },
  ];

  // Income categories
  static const List<Map<String, dynamic>> incomeCategories = [
    {'id': 'salary', 'name': 'Lương', 'icon': 0xe850, 'color': 0xFF00B894},
    {'id': 'bonus', 'name': 'Thưởng', 'icon': 0xea6f, 'color': 0xFF00CEC9},
    {'id': 'investment', 'name': 'Đầu tư', 'icon': 0xe8e5, 'color': 0xFF6C5CE7},
    {
      'id': 'gift_income',
      'name': 'Được tặng',
      'icon': 0xe8f6,
      'color': 0xFFFF85A2,
    },
    {'id': 'other_income', 'name': 'Khác', 'icon': 0xe8fe, 'color': 0xFFDFE6E9},
  ];
}
