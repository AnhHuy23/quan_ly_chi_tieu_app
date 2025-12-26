import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/category_model.dart';
import 'transaction_item.dart';

/// Transaction List Widget - Danh sách giao dịch grouped theo ngày
class TransactionList extends StatelessWidget {
  final Map<DateTime, List<TransactionModel>> transactionsByDate;
  final CategoryModel? Function(String id) getCategoryById;
  final void Function(TransactionModel transaction)? onTransactionTap;
  final void Function(String id)? onTransactionDelete;

  const TransactionList({
    super.key,
    required this.transactionsByDate,
    required this.getCategoryById,
    this.onTransactionTap,
    this.onTransactionDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (transactionsByDate.isEmpty) {
      return _buildEmptyState();
    }

    final sortedDates = transactionsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final transactions = transactionsByDate[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Text(
                    DateFormatter.formatRelative(date),
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(height: 1, color: AppColors.surfaceLight),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _calculateDayTotal(transactions),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: transactions.map((transaction) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: TransactionItem(
                      transaction: transaction,
                      category: getCategoryById(transaction.categoryId),
                      onTap: () => onTransactionTap?.call(transaction),
                      onDelete: () => onTransactionDelete?.call(transaction.id),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        );
      },
    );
  }

  String _calculateDayTotal(List<TransactionModel> transactions) {
    double income = 0;
    double expense = 0;

    for (final t in transactions) {
      if (t.isExpense) {
        expense += t.amount;
      } else {
        income += t.amount;
      }
    }

    final net = income - expense;
    if (net >= 0) {
      return '+${CurrencyFormatter.formatCompact(net)}';
    }
    return CurrencyFormatter.formatCompact(net);
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Chưa có giao dịch',
            style: AppTypography.heading3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Nhấn nút + để thêm giao dịch đầu tiên',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
