import 'locale_provider.dart';

/// English translations
class StringsEn implements AppStrings {
  // App
  @override
  String get appName => 'Expense Manager';

  // Navigation
  @override
  String get home => 'Home';
  @override
  String get statistics => 'Statistics';
  @override
  String get settings => 'Settings';

  // Home screen
  @override
  String get transactions => 'Transactions';
  @override
  String transactionCount(int count) => '$count transactions';
  @override
  String get balance => 'Balance';
  @override
  String get income => 'Income';
  @override
  String get expense => 'Expense';
  @override
  String get deletedTransaction => 'Transaction deleted';

  // Add transaction
  @override
  String get addTransaction => 'Add Transaction';
  @override
  String get editTransaction => 'Edit Transaction';
  @override
  String get amount => 'Amount';
  @override
  String get category => 'Category';
  @override
  String get note => 'Note';
  @override
  String get date => 'Date';
  @override
  String get save => 'Save';
  @override
  String get delete => 'Delete';
  @override
  String get cancel => 'Cancel';
  @override
  String get selectCategory => 'Select category';
  @override
  String get enterAmount => 'Enter amount';
  @override
  String get optional => 'Optional';
  @override
  String get incomeType => 'Income';
  @override
  String get expenseType => 'Expense';
  @override
  String get savedTransaction => 'Transaction saved';
  @override
  String get updatedTransaction => 'Transaction updated';
  @override
  String get confirmDelete => 'Confirm delete';
  @override
  String get confirmDeleteTransaction =>
      'Are you sure you want to delete this transaction?';

  // Statistics
  @override
  String get expenseByCategory => 'Expense by Category';
  @override
  String get incomeByCategory => 'Income by Category';
  @override
  String get thisMonth => 'This Month';
  @override
  String get noData => 'No data';
  @override
  String get total => 'Total';

  // Settings
  @override
  String get account => 'Account';
  @override
  String get personalInfo => 'Personal Info';
  @override
  String get nameAvatar => 'Name, avatar';
  @override
  String get notifications => 'Notifications';
  @override
  String get expenseReminders => 'Expense reminders';
  @override
  String get data => 'Data';
  @override
  String get categoryManagement => 'Category Management';
  @override
  String get addEditDeleteCategories => 'Add, edit, delete categories';
  @override
  String get exportData => 'Export Data';
  @override
  String get exportCSVExcel => 'Export CSV, Excel';
  @override
  String get importData => 'Import Data';
  @override
  String get importFromFile => 'Import from file';
  @override
  String get cloudBackup => 'Cloud Backup';
  @override
  String get syncGoogleDrive => 'Sync with Google Drive';
  @override
  String get dangerZone => 'Danger Zone';
  @override
  String get deleteAllTransactions => 'Delete All Transactions';
  @override
  String get cannotUndo => 'Cannot be undone';
  @override
  String get resetApp => 'Reset App';
  @override
  String get resetToDefault => 'Reset all data to default';
  @override
  String get info => 'Information';
  @override
  String get version => 'Version';
  @override
  String get rateApp => 'Rate App';
  @override
  String get giveUs5Stars => 'Give us 5 stars!';
  @override
  String get support => 'Support';
  @override
  String get sendFeedback => 'Send feedback';
  @override
  String get quickStats => 'Quick Stats';
  @override
  String get comingSoon => 'Coming soon';
  @override
  String get language => 'Language';
  @override
  String get selectLanguage => 'Select language';

  // Category management
  @override
  String get manageCategories => 'Manage Categories';
  @override
  String get addCategory => 'Add Category';
  @override
  String get categoryName => 'Category name';
  @override
  String get color => 'Color';
  @override
  String get icon => 'Icon';
  @override
  String get custom => 'Custom';
  @override
  String get defaultCategory => 'Default';
  @override
  String get noCategories => 'No categories';
  @override
  String get addedCategory => 'Category added';
  @override
  String get deleteCategory => 'Delete category?';
  @override
  String get confirmDeleteCategory =>
      'Are you sure you want to delete this category?';
  @override
  String get deletedCategory => 'Category deleted';
  @override
  String deleteCategoryConfirm(String name) =>
      'Are you sure you want to delete "$name"?';

  // Dialogs
  @override
  String get confirmDeleteAllTransactions => 'Delete all transactions?';
  @override
  String get deleteAllWarning =>
      'This action will permanently delete all transactions. You cannot undo this.';
  @override
  String get deletedAllTransactions => 'All transactions deleted';
  @override
  String get confirmResetApp => 'Reset app?';
  @override
  String get resetWarning =>
      'This action will delete all data and reset the app to default state.';
  @override
  String get appReset => 'App reset';
  @override
  String get add => 'Add';
  @override
  String get reset => 'Reset';
}
