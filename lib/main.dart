import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'presentation/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo locale data cho intl
  await initializeDateFormatting('vi_VN', null);

  // Khởi tạo repository
  final repository = TransactionRepository();
  await repository.init();

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TransactionRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: repository,
      child: MaterialApp(
        title: 'Quản lý chi tiêu',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
