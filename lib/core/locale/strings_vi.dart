import 'locale_provider.dart';

/// Vietnamese translations
class StringsVi implements AppStrings {
  // App
  @override
  String get appName => 'Quản lý chi tiêu';

  // Navigation
  @override
  String get home => 'Trang chủ';
  @override
  String get statistics => 'Thống kê';
  @override
  String get settings => 'Cài đặt';

  // Home screen
  @override
  String get transactions => 'Giao dịch';
  @override
  String transactionCount(int count) => '$count giao dịch';
  @override
  String get balance => 'Số dư';
  @override
  String get income => 'Thu nhập';
  @override
  String get expense => 'Chi tiêu';
  @override
  String get deletedTransaction => 'Đã xóa giao dịch';

  // Add transaction
  @override
  String get addTransaction => 'Thêm giao dịch';
  @override
  String get editTransaction => 'Sửa giao dịch';
  @override
  String get amount => 'Số tiền';
  @override
  String get category => 'Danh mục';
  @override
  String get note => 'Ghi chú';
  @override
  String get date => 'Ngày';
  @override
  String get save => 'Lưu';
  @override
  String get delete => 'Xóa';
  @override
  String get cancel => 'Hủy';
  @override
  String get selectCategory => 'Chọn danh mục';
  @override
  String get enterAmount => 'Nhập số tiền';
  @override
  String get optional => 'Tùy chọn';
  @override
  String get incomeType => 'Thu nhập';
  @override
  String get expenseType => 'Chi tiêu';
  @override
  String get savedTransaction => 'Đã lưu giao dịch';
  @override
  String get updatedTransaction => 'Đã cập nhật giao dịch';
  @override
  String get confirmDelete => 'Xác nhận xóa';
  @override
  String get confirmDeleteTransaction => 'Bạn có chắc muốn xóa giao dịch này?';

  // Statistics
  @override
  String get expenseByCategory => 'Chi tiêu theo danh mục';
  @override
  String get incomeByCategory => 'Thu nhập theo danh mục';
  @override
  String get thisMonth => 'Tháng này';
  @override
  String get noData => 'Không có dữ liệu';
  @override
  String get total => 'Tổng';

  // Settings
  @override
  String get account => 'Tài khoản';
  @override
  String get personalInfo => 'Thông tin cá nhân';
  @override
  String get nameAvatar => 'Tên, avatar';
  @override
  String get notifications => 'Thông báo';
  @override
  String get expenseReminders => 'Nhắc nhở chi tiêu';
  @override
  String get data => 'Dữ liệu';
  @override
  String get categoryManagement => 'Quản lý danh mục';
  @override
  String get addEditDeleteCategories => 'Thêm, sửa, xóa danh mục';
  @override
  String get exportData => 'Xuất dữ liệu';
  @override
  String get exportCSVExcel => 'Xuất CSV, Excel';
  @override
  String get importData => 'Nhập dữ liệu';
  @override
  String get importFromFile => 'Nhập từ file';
  @override
  String get cloudBackup => 'Sao lưu đám mây';
  @override
  String get syncGoogleDrive => 'Sync với Google Drive';
  @override
  String get dangerZone => 'Vùng nguy hiểm';
  @override
  String get deleteAllTransactions => 'Xóa tất cả giao dịch';
  @override
  String get cannotUndo => 'Không thể hoàn tác';
  @override
  String get resetApp => 'Reset ứng dụng';
  @override
  String get resetToDefault => 'Xóa mọi dữ liệu về mặc định';
  @override
  String get info => 'Thông tin';
  @override
  String get version => 'Phiên bản';
  @override
  String get rateApp => 'Đánh giá ứng dụng';
  @override
  String get giveUs5Stars => 'Cho chúng tôi 5 sao!';
  @override
  String get support => 'Hỗ trợ';
  @override
  String get sendFeedback => 'Gửi phản hồi';
  @override
  String get quickStats => 'Thống kê nhanh';
  @override
  String get comingSoon => 'Tính năng đang phát triển';
  @override
  String get language => 'Ngôn ngữ';
  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  // Category management
  @override
  String get manageCategories => 'Quản lý danh mục';
  @override
  String get addCategory => 'Thêm danh mục';
  @override
  String get categoryName => 'Tên danh mục';
  @override
  String get color => 'Màu sắc';
  @override
  String get icon => 'Icon';
  @override
  String get custom => 'Tùy chỉnh';
  @override
  String get defaultCategory => 'Mặc định';
  @override
  String get noCategories => 'Chưa có danh mục';
  @override
  String get addedCategory => 'Đã thêm danh mục';
  @override
  String get deleteCategory => 'Xóa danh mục?';
  @override
  String get confirmDeleteCategory => 'Bạn có chắc muốn xóa danh mục này?';
  @override
  String get deletedCategory => 'Đã xóa danh mục';
  @override
  String deleteCategoryConfirm(String name) => 'Bạn có chắc muốn xóa "$name"?';

  // Dialogs
  @override
  String get confirmDeleteAllTransactions => 'Xóa tất cả giao dịch?';
  @override
  String get deleteAllWarning =>
      'Hành động này sẽ xóa vĩnh viễn tất cả giao dịch. Bạn không thể hoàn tác.';
  @override
  String get deletedAllTransactions => 'Đã xóa tất cả giao dịch';
  @override
  String get confirmResetApp => 'Reset ứng dụng?';
  @override
  String get resetWarning =>
      'Hành động này sẽ xóa toàn bộ dữ liệu và đưa ứng dụng về trạng thái mặc định.';
  @override
  String get appReset => 'Đã reset ứng dụng';
  @override
  String get add => 'Thêm';
  @override
  String get reset => 'Reset';
}
