import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/locale/locale_provider.dart';
import '../../data/repositories/transaction_repository_impl.dart';

/// Category Management Screen
class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LocaleProvider>().strings;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(strings.manageCategories),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: strings.expenseType),
              Tab(text: strings.incomeType),
            ],
          ),
        ),
        body: Consumer<TransactionRepository>(
          builder: (context, repo, _) {
            return TabBarView(
              children: [
                _CategoryList(categories: repo.expenseCategories),
                _CategoryList(categories: repo.incomeCategories),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddCategoryDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const _AddCategoryDialog());
  }
}

/// Category list widget
class _CategoryList extends StatelessWidget {
  final List categories;

  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LocaleProvider>().strings;

    if (categories.isEmpty) {
      return Center(
        child: Text(
          strings.noCategories,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final color = Color(category.colorValue);

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mediumRadius,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: AppRadius.smallRadius,
                ),
                child: Icon(
                  IconData(category.iconCode, fontFamily: 'MaterialIcons'),
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name, style: AppTypography.bodyLarge),
                    Text(
                      category.isCustom
                          ? strings.custom
                          : strings.defaultCategory,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              if (category.isCustom)
                IconButton(
                  onPressed: () => _showDeleteDialog(context, category),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic category) {
    final strings = context.read<LocaleProvider>().strings;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(strings.deleteCategory),
        content: Text(strings.deleteCategoryConfirm(category.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () async {
              final repo = context.read<TransactionRepository>();
              await repo.deleteCategory(category.id);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(strings.deletedCategory)),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
  }
}

/// Add category dialog
class _AddCategoryDialog extends StatefulWidget {
  const _AddCategoryDialog();

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  final _nameController = TextEditingController();
  bool _isExpense = true;
  int _selectedColorIndex = 0;
  int _selectedIconIndex = 0;

  static const _colors = [
    0xFFFF7675,
    0xFF74B9FF,
    0xFFFD79A8,
    0xFFA29BFE,
    0xFFFDCB6E,
    0xFF55EFC4,
    0xFF81ECEC,
    0xFF00B894,
  ];

  static const _icons = [
    Icons.shopping_bag,
    Icons.restaurant,
    Icons.directions_car,
    Icons.movie,
    Icons.home,
    Icons.favorite,
    Icons.school,
    Icons.sports_esports,
    Icons.work,
    Icons.flight,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LocaleProvider>().strings;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(strings.addCategory),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: strings.categoryName),
            ),
            const SizedBox(height: AppSpacing.md),

            // Type selector
            Row(
              children: [
                Expanded(
                  child: _TypeChip(
                    label: strings.expenseType,
                    isSelected: _isExpense,
                    onTap: () => setState(() => _isExpense = true),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _TypeChip(
                    label: strings.incomeType,
                    isSelected: !_isExpense,
                    onTap: () => setState(() => _isExpense = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Color selector
            Text(strings.color, style: AppTypography.bodySmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors.asMap().entries.map((entry) {
                final isSelected = _selectedColorIndex == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = entry.key),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(entry.value),
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),

            // Icon selector
            Text(strings.icon, style: AppTypography.bodySmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _icons.asMap().entries.map((entry) {
                final isSelected = _selectedIconIndex == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIconIndex = entry.key),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Icon(
                      entry.value,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(strings.cancel),
        ),
        ElevatedButton(onPressed: _addCategory, child: Text(strings.add)),
      ],
    );
  }

  Future<void> _addCategory() async {
    if (_nameController.text.trim().isEmpty) return;

    final strings = context.read<LocaleProvider>().strings;
    final repo = context.read<TransactionRepository>();

    await repo.addCategory(
      name: _nameController.text.trim(),
      iconCode: _icons[_selectedIconIndex].codePoint,
      colorValue: _colors[_selectedColorIndex],
      isExpense: _isExpense,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.addedCategory)));
    }
  }
}

/// Type chip for expense/income selection
class _TypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surfaceLight,
          borderRadius: AppRadius.smallRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
