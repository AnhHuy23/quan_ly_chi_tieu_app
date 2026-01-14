import 'locale_provider.dart';

/// Korean translations
class StringsKo implements AppStrings {
  // App
  @override
  String get appName => '지출 관리';

  // Navigation
  @override
  String get home => '홈';
  @override
  String get statistics => '통계';
  @override
  String get settings => '설정';

  // Home screen
  @override
  String get transactions => '거래';
  @override
  String transactionCount(int count) => '거래 $count건';
  @override
  String get balance => '잔액';
  @override
  String get income => '수입';
  @override
  String get expense => '지출';
  @override
  String get deletedTransaction => '거래가 삭제되었습니다';

  // Add transaction
  @override
  String get addTransaction => '거래 추가';
  @override
  String get editTransaction => '거래 수정';
  @override
  String get amount => '금액';
  @override
  String get category => '카테고리';
  @override
  String get note => '메모';
  @override
  String get date => '날짜';
  @override
  String get save => '저장';
  @override
  String get delete => '삭제';
  @override
  String get cancel => '취소';
  @override
  String get selectCategory => '카테고리 선택';
  @override
  String get enterAmount => '금액 입력';
  @override
  String get optional => '선택사항';
  @override
  String get incomeType => '수입';
  @override
  String get expenseType => '지출';
  @override
  String get savedTransaction => '거래가 저장되었습니다';
  @override
  String get updatedTransaction => '거래가 업데이트되었습니다';
  @override
  String get confirmDelete => '삭제 확인';
  @override
  String get confirmDeleteTransaction => '이 거래를 삭제하시겠습니까?';

  // Statistics
  @override
  String get expenseByCategory => '카테고리별 지출';
  @override
  String get incomeByCategory => '카테고리별 수입';
  @override
  String get thisMonth => '이번 달';
  @override
  String get noData => '데이터 없음';
  @override
  String get total => '합계';

  // Settings
  @override
  String get account => '계정';
  @override
  String get personalInfo => '개인 정보';
  @override
  String get nameAvatar => '이름, 아바타';
  @override
  String get notifications => '알림';
  @override
  String get expenseReminders => '지출 알림';
  @override
  String get data => '데이터';
  @override
  String get categoryManagement => '카테고리 관리';
  @override
  String get addEditDeleteCategories => '카테고리 추가, 수정, 삭제';
  @override
  String get exportData => '데이터 내보내기';
  @override
  String get exportCSVExcel => 'CSV, Excel 내보내기';
  @override
  String get importData => '데이터 가져오기';
  @override
  String get importFromFile => '파일에서 가져오기';
  @override
  String get cloudBackup => '클라우드 백업';
  @override
  String get syncGoogleDrive => 'Google 드라이브와 동기화';
  @override
  String get dangerZone => '위험 구역';
  @override
  String get deleteAllTransactions => '모든 거래 삭제';
  @override
  String get cannotUndo => '취소할 수 없습니다';
  @override
  String get resetApp => '앱 초기화';
  @override
  String get resetToDefault => '모든 데이터를 기본값으로 재설정';
  @override
  String get info => '정보';
  @override
  String get version => '버전';
  @override
  String get rateApp => '앱 평가';
  @override
  String get giveUs5Stars => '별 5개를 주세요!';
  @override
  String get support => '지원';
  @override
  String get sendFeedback => '피드백 보내기';
  @override
  String get quickStats => '빠른 통계';
  @override
  String get comingSoon => '곧 제공 예정';
  @override
  String get language => '언어';
  @override
  String get selectLanguage => '언어 선택';

  // Category management
  @override
  String get manageCategories => '카테고리 관리';
  @override
  String get addCategory => '카테고리 추가';
  @override
  String get categoryName => '카테고리 이름';
  @override
  String get color => '색상';
  @override
  String get icon => '아이콘';
  @override
  String get custom => '사용자 정의';
  @override
  String get defaultCategory => '기본';
  @override
  String get noCategories => '카테고리 없음';
  @override
  String get addedCategory => '카테고리가 추가되었습니다';
  @override
  String get deleteCategory => '카테고리 삭제?';
  @override
  String get confirmDeleteCategory => '이 카테고리를 삭제하시겠습니까?';
  @override
  String get deletedCategory => '카테고리가 삭제되었습니다';
  @override
  String deleteCategoryConfirm(String name) => '"$name"을(를) 삭제하시겠습니까?';

  // Dialogs
  @override
  String get confirmDeleteAllTransactions => '모든 거래를 삭제하시겠습니까?';
  @override
  String get deleteAllWarning => '이 작업은 모든 거래를 영구적으로 삭제합니다. 취소할 수 없습니다.';
  @override
  String get deletedAllTransactions => '모든 거래가 삭제되었습니다';
  @override
  String get confirmResetApp => '앱을 초기화하시겠습니까?';
  @override
  String get resetWarning => '이 작업은 모든 데이터를 삭제하고 앱을 기본 상태로 재설정합니다.';
  @override
  String get appReset => '앱이 초기화되었습니다';
  @override
  String get add => '추가';
  @override
  String get reset => '초기화';
}
