import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/category_model.dart';

/// Transaction Item Widget - Hiển thị 1 giao dịch
class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final CategoryModel? category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.category,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = Color(category?.colorValue ?? 0xFF6C5CE7);
    final isExpense = transaction.isExpense;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppRadius.mediumRadius,
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mediumRadius,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mediumRadius,
          ),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.mediumRadius,
                ),
                child: Icon(
                  IconData(
                    category?.iconCode ?? Icons.category.codePoint,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: categoryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category?.name ?? 'Không xác định',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (transaction.note.isNotEmpty)
                      Text(
                        transaction.note,
                        style: AppTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Amount
              Text(
                CurrencyFormatter.formatWithSign(
                  transaction.amount,
                  isExpense: isExpense,
                ),
                style: AppTypography.amountSmall.copyWith(
                  color: isExpense ? AppColors.expense : AppColors.income,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
