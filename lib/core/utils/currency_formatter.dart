import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Currency Formatter Utility
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: AppConstants.locale,
    symbol: AppConstants.currencySymbol,
    decimalDigits: 0,
  );

  /// Format số tiền đầy đủ: 1,500,000 ₫
  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  /// Format số tiền rút gọn: 1.5M
  static String formatCompact(double amount) {
    if (amount.abs() >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B ${AppConstants.currencySymbol}';
    } else if (amount.abs() >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M ${AppConstants.currencySymbol}';
    } else if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K ${AppConstants.currencySymbol}';
    }
    return format(amount);
  }

  /// Format số tiền với dấu + hoặc -
  static String formatWithSign(double amount, {bool isExpense = true}) {
    final sign = isExpense ? '-' : '+';
    return '$sign${format(amount.abs())}';
  }

  /// Parse string về số
  static double parse(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanValue) ?? 0;
  }
}

/// Date Formatter Utility
class DateFormatter {
  DateFormatter._();

  static final DateFormat _fullFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  /// Format ngày đầy đủ: 26/12/2024
  static String formatFull(DateTime date) {
    return _fullFormat.format(date);
  }

  /// Format tháng năm: Tháng 12 2024
  static String formatMonthYear(DateTime date) {
    return 'Tháng ${date.month} ${date.year}';
  }

  /// Format ngày tháng: 26 Tháng 12
  static String formatDayMonth(DateTime date) {
    return '${date.day} Tháng ${date.month}';
  }

  /// Format thời gian: 14:30
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Kiểm tra có phải hôm nay không
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Kiểm tra có phải hôm qua không
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Format ngày thân thiện: Hôm nay, Hôm qua, hoặc ngày cụ thể
  static String formatRelative(DateTime date) {
    if (isToday(date)) {
      return 'Hôm nay';
    } else if (isYesterday(date)) {
      return 'Hôm qua';
    } else {
      return formatFull(date);
    }
  }

  /// Lấy ngày đầu tháng
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Lấy ngày cuối tháng
  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Lấy số ngày trong tháng
  static int getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }
}
