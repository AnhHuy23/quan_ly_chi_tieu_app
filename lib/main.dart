import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/error/app_error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Khởi tạo locale data cho intl
    await initializeDateFormatting('vi_VN', null);

    // Khởi tạo repository
    final repository = TransactionRepository();
    await repository.init();

    runApp(MyApp(repository: repository));
  } catch (e, stack) {
    // Log error và show error UI thay vì crash
    debugPrint('=== APP INITIALIZATION FAILED ===');
    debugPrint('Error: $e');
    debugPrint('Stack trace: $stack');

    runApp(AppErrorScreen(errorMessage: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  final TransactionRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    // Dùng ChangeNotifierProvider thay vì .value để Provider quản lý lifecycle
    // và tự động dispose khi không còn cần thiết
    return ChangeNotifierProvider<TransactionRepository>(
      create: (_) => repository,
      child: MaterialApp(
        title: 'Quản lý chi tiêu',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
