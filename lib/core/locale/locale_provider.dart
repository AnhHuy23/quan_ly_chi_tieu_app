import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'strings_vi.dart';
import 'strings_en.dart';
import 'strings_ko.dart';
import 'strings_zh.dart';

/// Supported languages
enum AppLanguage {
  vietnamese('vi', 'Tiếng Việt', '🇻🇳'),
  english('en', 'English', '🇺🇸'),
  korean('ko', '한국어', '🇰🇷'),
  chinese('zh', '中文', '🇨🇳');

  final String code;
  final String name;
  final String flag;

  const AppLanguage(this.code, this.name, this.flag);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.vietnamese,
    );
  }
}

/// Locale strings interface
abstract class AppStrings {
  // App
  String get appName;

  // Navigation
  String get home;
  String get statistics;
  String get settings;

  // Home screen
  String get transactions;
  String transactionCount(int count);
  String get balance;
  String get income;
  String get expense;
  String get deletedTransaction;

  // Add transaction
  String get addTransaction;
  String get editTransaction;
  String get amount;
  String get category;
  String get note;
  String get date;
  String get save;
  String get delete;
  String get cancel;
  String get selectCategory;
  String get enterAmount;
  String get optional;
  String get incomeType;
  String get expenseType;
  String get savedTransaction;
  String get updatedTransaction;
  String get confirmDelete;
  String get confirmDeleteTransaction;

  // Statistics
  String get expenseByCategory;
  String get incomeByCategory;
  String get thisMonth;
  String get noData;
  String get total;

  // Settings
  String get account;
  String get personalInfo;
  String get nameAvatar;
  String get notifications;
  String get expenseReminders;
  String get data;
  String get categoryManagement;
  String get addEditDeleteCategories;
  String get exportData;
  String get exportCSVExcel;
  String get importData;
  String get importFromFile;
  String get cloudBackup;
  String get syncGoogleDrive;
  String get dangerZone;
  String get deleteAllTransactions;
  String get cannotUndo;
  String get resetApp;
  String get resetToDefault;
  String get info;
  String get version;
  String get rateApp;
  String get giveUs5Stars;
  String get support;
  String get sendFeedback;
  String get quickStats;
  String get comingSoon;
  String get language;
  String get selectLanguage;

  // Category management
  String get manageCategories;
  String get addCategory;
  String get categoryName;
  String get color;
  String get icon;
  String get custom;
  String get defaultCategory;
  String get noCategories;
  String get addedCategory;
  String get deleteCategory;
  String get confirmDeleteCategory;
  String get deletedCategory;
  String deleteCategoryConfirm(String name);

  // Dialogs
  String get confirmDeleteAllTransactions;
  String get deleteAllWarning;
  String get deletedAllTransactions;
  String get confirmResetApp;
  String get resetWarning;
  String get appReset;
  String get add;
  String get reset;
}

/// Locale Provider - manages app language
class LocaleProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _languageKey = 'language';

  late Box _settingsBox;
  AppLanguage _currentLanguage = AppLanguage.vietnamese;
  late AppStrings _strings;

  AppLanguage get currentLanguage => _currentLanguage;
  AppStrings get strings => _strings;

  /// Initialize provider
  Future<void> init() async {
    _settingsBox = await Hive.openBox(_boxName);
    final savedCode = _settingsBox.get(_languageKey, defaultValue: 'vi');
    _currentLanguage = AppLanguage.fromCode(savedCode);
    _updateStrings();
  }

  /// Change language
  Future<void> changeLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;

    _currentLanguage = language;
    await _settingsBox.put(_languageKey, language.code);
    _updateStrings();
    notifyListeners();
  }

  void _updateStrings() {
    switch (_currentLanguage) {
      case AppLanguage.vietnamese:
        _strings = StringsVi();
        break;
      case AppLanguage.english:
        _strings = StringsEn();
        break;
      case AppLanguage.korean:
        _strings = StringsKo();
        break;
      case AppLanguage.chinese:
        _strings = StringsZh();
        break;
    }
  }
}
