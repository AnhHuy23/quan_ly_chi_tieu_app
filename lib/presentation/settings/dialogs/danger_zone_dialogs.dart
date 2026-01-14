import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../data/repositories/transaction_repository_impl.dart';

/// Show delete all transactions confirmation dialog
Future<bool> showDeleteAllTransactionsDialog(BuildContext context) async {
  final strings = context.read<LocaleProvider>().strings;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(strings.confirmDeleteAllTransactions),
      content: Text(strings.deleteAllWarning),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(strings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(strings.delete),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    final repo = context.read<TransactionRepository>();
    await repo.deleteAllTransactions();

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.deletedAllTransactions)));
    }
    return true;
  }
  return false;
}

/// Show reset app confirmation dialog
Future<bool> showResetAppDialog(BuildContext context) async {
  final strings = context.read<LocaleProvider>().strings;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(strings.confirmResetApp),
      content: Text(strings.resetWarning),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(strings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(strings.reset),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    final repo = context.read<TransactionRepository>();
    await repo.resetApp();

    // Reset language to Vietnamese
    final localeProvider = context.read<LocaleProvider>();
    await localeProvider.changeLanguage(AppLanguage.vietnamese);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.appReset)));
    }
    return true;
  }
  return false;
}
