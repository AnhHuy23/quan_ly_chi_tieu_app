import 'locale_provider.dart';

/// Chinese (Simplified) translations
class StringsZh implements AppStrings {
  // App
  @override
  String get appName => '支出管理';

  // Navigation
  @override
  String get home => '首页';
  @override
  String get statistics => '统计';
  @override
  String get settings => '设置';

  // Home screen
  @override
  String get transactions => '交易';
  @override
  String transactionCount(int count) => '$count 笔交易';
  @override
  String get balance => '余额';
  @override
  String get income => '收入';
  @override
  String get expense => '支出';
  @override
  String get deletedTransaction => '交易已删除';

  // Add transaction
  @override
  String get addTransaction => '添加交易';
  @override
  String get editTransaction => '编辑交易';
  @override
  String get amount => '金额';
  @override
  String get category => '类别';
  @override
  String get note => '备注';
  @override
  String get date => '日期';
  @override
  String get save => '保存';
  @override
  String get delete => '删除';
  @override
  String get cancel => '取消';
  @override
  String get selectCategory => '选择类别';
  @override
  String get enterAmount => '输入金额';
  @override
  String get optional => '可选';
  @override
  String get incomeType => '收入';
  @override
  String get expenseType => '支出';
  @override
  String get savedTransaction => '交易已保存';
  @override
  String get updatedTransaction => '交易已更新';
  @override
  String get confirmDelete => '确认删除';
  @override
  String get confirmDeleteTransaction => '确定要删除这笔交易吗？';

  // Statistics
  @override
  String get expenseByCategory => '按类别支出';
  @override
  String get incomeByCategory => '按类别收入';
  @override
  String get thisMonth => '本月';
  @override
  String get noData => '暂无数据';
  @override
  String get total => '总计';

  // Settings
  @override
  String get account => '账户';
  @override
  String get personalInfo => '个人信息';
  @override
  String get nameAvatar => '姓名、头像';
  @override
  String get notifications => '通知';
  @override
  String get expenseReminders => '支出提醒';
  @override
  String get data => '数据';
  @override
  String get categoryManagement => '类别管理';
  @override
  String get addEditDeleteCategories => '添加、编辑、删除类别';
  @override
  String get exportData => '导出数据';
  @override
  String get exportCSVExcel => '导出 CSV、Excel';
  @override
  String get importData => '导入数据';
  @override
  String get importFromFile => '从文件导入';
  @override
  String get cloudBackup => '云备份';
  @override
  String get syncGoogleDrive => '与 Google 云端硬盘同步';
  @override
  String get dangerZone => '危险区域';
  @override
  String get deleteAllTransactions => '删除所有交易';
  @override
  String get cannotUndo => '无法撤销';
  @override
  String get resetApp => '重置应用';
  @override
  String get resetToDefault => '将所有数据重置为默认';
  @override
  String get info => '信息';
  @override
  String get version => '版本';
  @override
  String get rateApp => '评价应用';
  @override
  String get giveUs5Stars => '给我们5星好评！';
  @override
  String get support => '支持';
  @override
  String get sendFeedback => '发送反馈';
  @override
  String get quickStats => '快速统计';
  @override
  String get comingSoon => '即将推出';
  @override
  String get language => '语言';
  @override
  String get selectLanguage => '选择语言';

  // Category management
  @override
  String get manageCategories => '管理类别';
  @override
  String get addCategory => '添加类别';
  @override
  String get categoryName => '类别名称';
  @override
  String get color => '颜色';
  @override
  String get icon => '图标';
  @override
  String get custom => '自定义';
  @override
  String get defaultCategory => '默认';
  @override
  String get noCategories => '暂无类别';
  @override
  String get addedCategory => '类别已添加';
  @override
  String get deleteCategory => '删除类别？';
  @override
  String get confirmDeleteCategory => '确定要删除这个类别吗？';
  @override
  String get deletedCategory => '类别已删除';
  @override
  String deleteCategoryConfirm(String name) => '确定要删除"$name"吗？';

  // Dialogs
  @override
  String get confirmDeleteAllTransactions => '删除所有交易？';
  @override
  String get deleteAllWarning => '此操作将永久删除所有交易。无法撤销。';
  @override
  String get deletedAllTransactions => '所有交易已删除';
  @override
  String get confirmResetApp => '重置应用？';
  @override
  String get resetWarning => '此操作将删除所有数据并将应用重置为默认状态。';
  @override
  String get appReset => '应用已重置';
  @override
  String get add => '添加';
  @override
  String get reset => '重置';
}
