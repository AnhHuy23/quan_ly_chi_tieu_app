import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/transaction_repository_impl.dart';

/// Add/Edit Transaction Screen
class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isExpense = true;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  bool get isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final t = widget.transaction!;
      _amountController.text = t.amount.toStringAsFixed(0);
      _noteController.text = t.note;
      _isExpense = t.isExpense;
      _selectedCategoryId = t.categoryId;
      _selectedDate = t.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<TransactionRepository>();
    final categories = _isExpense
        ? repo.expenseCategories
        : repo.incomeCategories;

    // Auto-select first category if none selected
    if (_selectedCategoryId == null && categories.isNotEmpty) {
      _selectedCategoryId = categories.first.id;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch'),
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _deleteTransaction,
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Transaction type toggle
            _buildTypeToggle(),
            const SizedBox(height: AppSpacing.lg),

            // Amount input
            _buildAmountInput(),
            const SizedBox(height: AppSpacing.lg),

            // Category selector
            _buildCategorySelector(categories),
            const SizedBox(height: AppSpacing.lg),

            // Date picker
            _buildDatePicker(),
            const SizedBox(height: AppSpacing.lg),

            // Note input
            _buildNoteInput(),
            const SizedBox(height: AppSpacing.xl),

            // Save button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.largeRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton(
              label: 'Chi tiêu',
              icon: Icons.arrow_upward_rounded,
              isSelected: _isExpense,
              color: AppColors.expense,
              onTap: () => setState(() {
                _isExpense = true;
                _selectedCategoryId = null;
              }),
            ),
          ),
          Expanded(
            child: _buildTypeButton(
              label: 'Thu nhập',
              icon: Icons.arrow_downward_rounded,
              isSelected: !_isExpense,
              color: AppColors.income,
              onTap: () => setState(() {
                _isExpense = false;
                _selectedCategoryId = null;
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: AppRadius.mediumRadius,
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Số tiền',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: AppTypography.amount.copyWith(
            color: _isExpense ? AppColors.expense : AppColors.income,
          ),
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _ThousandsSeparatorInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: AppTypography.amount.copyWith(color: AppColors.textHint),
            suffixText: '₫',
            suffixStyle: AppTypography.heading2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập số tiền';
            }
            final amount = CurrencyFormatter.parse(value);
            if (amount <= 0) {
              return 'Số tiền phải lớn hơn 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelector(List<CategoryModel> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh mục',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: categories.map((category) {
            final isSelected = _selectedCategoryId == category.id;
            final color = Color(category.colorValue);

            return GestureDetector(
              onTap: () => setState(() => _selectedCategoryId = category.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: AppRadius.largeRadius,
                  border: Border.all(
                    color: isSelected ? color : AppColors.surfaceLight,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      IconData(category.iconCode, fontFamily: 'MaterialIcons'),
                      color: isSelected ? color : AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      category.name,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isSelected ? color : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: _selectDate,
          borderRadius: AppRadius.mediumRadius,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  DateFormatter.formatFull(_selectedDate),
                  style: AppTypography.bodyLarge,
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ghi chú',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _noteController,
          maxLines: 2,
          style: AppTypography.bodyLarge,
          decoration: const InputDecoration(
            hintText: 'Thêm ghi chú (tùy chọn)',
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isExpense ? AppColors.expense : AppColors.income,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              isEditing ? 'Cập nhật' : 'Thêm giao dịch',
              style: AppTypography.button,
            ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng chọn danh mục')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = context.read<TransactionRepository>();
      final amount = CurrencyFormatter.parse(_amountController.text);

      if (isEditing) {
        final updated = widget.transaction!.copyWith(
          amount: amount,
          categoryId: _selectedCategoryId,
          note: _noteController.text.trim(),
          date: _selectedDate,
          isExpense: _isExpense,
        );
        await repo.updateTransaction(updated);
      } else {
        await repo.addTransaction(
          amount: amount,
          categoryId: _selectedCategoryId!,
          note: _noteController.text.trim(),
          date: _selectedDate,
          isExpense: _isExpense,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Đã cập nhật giao dịch' : 'Đã thêm giao dịch',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteTransaction() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Xóa giao dịch?'),
        content: const Text('Bạn có chắc muốn xóa giao dịch này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final repo = context.read<TransactionRepository>();
      await repo.deleteTransaction(widget.transaction!.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa giao dịch')));
    }
  }
}

/// Input formatter for thousands separator
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final number = int.tryParse(digits) ?? 0;
    final formatted = number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
