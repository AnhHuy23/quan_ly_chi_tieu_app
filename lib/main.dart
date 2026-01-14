import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/locale/locale_provider.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/error/app_error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Khởi tạo Hive trước tiên
    await Hive.initFlutter();

    // Khởi tạo locale data cho intl
    await initializeDateFormatting('vi_VN', null);

    // Khởi tạo locale provider
    final localeProvider = LocaleProvider();
    await localeProvider.init();

    // Khởi tạo repository
    final repository = TransactionRepository();
    await repository.init();

    runApp(MyApp(repository: repository, localeProvider: localeProvider));
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
  final LocaleProvider localeProvider;

  const MyApp({
    super.key,
    required this.repository,
    required this.localeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TransactionRepository>.value(value: repository),
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, locale, _) {
          return MaterialApp(
            title: locale.strings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
