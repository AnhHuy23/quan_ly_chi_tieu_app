import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/repositories/transaction_repository_impl.dart';

/// Settings Screen - Màn hình cài đặt
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Account section
          _buildSectionHeader('Tài khoản'),
          _buildSettingCard(
            children: [
              _buildSettingItem(
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                title: 'Thông tin cá nhân',
                subtitle: 'Tên, avatar',
                onTap: () => _showComingSoon(context),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.warning,
                title: 'Thông báo',
                subtitle: 'Nhắc nhở chi tiêu',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Data section
          _buildSectionHeader('Dữ liệu'),
          _buildSettingCard(
            children: [
              _buildSettingItem(
                icon: Icons.category_outlined,
                iconColor: AppColors.secondary,
                title: 'Quản lý danh mục',
                subtitle: 'Thêm, sửa, xóa danh mục',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryManagementScreen(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.download_outlined,
                iconColor: AppColors.income,
                title: 'Xuất dữ liệu',
                subtitle: 'Xuất CSV, Excel',
                onTap: () => _showComingSoon(context),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.upload_outlined,
                iconColor: AppColors.info,
                title: 'Nhập dữ liệu',
                subtitle: 'Nhập từ file',
                onTap: () => _showComingSoon(context),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.cloud_outlined,
                iconColor: AppColors.primary,
                title: 'Sao lưu đám mây',
                subtitle: 'Sync với Google Drive',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Danger zone
          _buildSectionHeader('Vùng nguy hiểm'),
          _buildSettingCard(
            children: [
              _buildSettingItem(
                icon: Icons.delete_forever_outlined,
                iconColor: AppColors.error,
                title: 'Xóa tất cả giao dịch',
                subtitle: 'Không thể hoàn tác',
                onTap: () => _showDeleteAllDialog(context),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.refresh_outlined,
                iconColor: AppColors.warning,
                title: 'Reset ứng dụng',
                subtitle: 'Xóa mọi dữ liệu về mặc định',
                onTap: () => _showResetDialog(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // About section
          _buildSectionHeader('Thông tin'),
          _buildSettingCard(
            children: [
              _buildSettingItem(
                icon: Icons.info_outline,
                iconColor: AppColors.textSecondary,
                title: 'Phiên bản',
                subtitle: '1.0.0',
                onTap: null,
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.star_outline,
                iconColor: AppColors.warning,
                title: 'Đánh giá ứng dụng',
                subtitle: 'Cho chúng tôi 5 sao!',
                onTap: () => _showComingSoon(context),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.help_outline,
                iconColor: AppColors.info,
                title: 'Hỗ trợ',
                subtitle: 'Gửi phản hồi',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Stats
          Consumer<TransactionRepository>(
            builder: (context, repo, _) {
              return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.mediumRadius,
                ),
                child: Column(
                  children: [
                    Text(
                      'Thống kê nhanh',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickStat(
                          label: 'Giao dịch',
                          value: '${repo.transactions.length}',
                        ),
                        _buildQuickStat(
                          label: 'Số dư',
                          value: CurrencyFormatter.formatCompact(
                            repo.totalBalance,
                          ),
                        ),
                        _buildQuickStat(
                          label: 'Danh mục',
                          value: '${repo.categories.length}',
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.largeRadius,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.largeRadius,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: AppRadius.smallRadius,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodyLarge),
                  Text(subtitle, style: AppTypography.caption),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 72, color: AppColors.surfaceLight);
  }

  Widget _buildQuickStat({required String label, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.heading3.copyWith(color: AppColors.primary),
        ),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng đang phát triển'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Xóa tất cả giao dịch?'),
        content: const Text(
          'Hành động này sẽ xóa vĩnh viễn tất cả giao dịch. Bạn không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete all
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa tất cả giao dịch')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Reset ứng dụng?'),
        content: const Text(
          'Hành động này sẽ xóa toàn bộ dữ liệu và đưa ứng dụng về trạng thái mặc định.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement reset
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã reset ứng dụng')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

// ============ Category Management Screen ============

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Quản lý danh mục'),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Chi tiêu'),
              Tab(text: 'Thu nhập'),
            ],
          ),
        ),
        body: Consumer<TransactionRepository>(
          builder: (context, repo, _) {
            return TabBarView(
              children: [
                _buildCategoryList(context, repo.expenseCategories, true),
                _buildCategoryList(context, repo.incomeCategories, false),
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

  Widget _buildCategoryList(
    BuildContext context,
    List categories,
    bool isExpense,
  ) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          'Chưa có danh mục',
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
                      category.isCustom ? 'Tùy chỉnh' : 'Mặc định',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              if (category.isCustom)
                IconButton(
                  onPressed: () {
                    _showDeleteCategoryDialog(context, category);
                  },
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

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    bool isExpense = true;
    int selectedColorIndex = 0;
    int selectedIconIndex = 0;

    final colors = [
      0xFFFF7675,
      0xFF74B9FF,
      0xFFFD79A8,
      0xFFA29BFE,
      0xFFFDCB6E,
      0xFF55EFC4,
      0xFF81ECEC,
      0xFF00B894,
    ];

    final icons = [
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

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Thêm danh mục'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Tên danh mục'),
                ),
                const SizedBox(height: AppSpacing.md),

                // Type selector
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeChip(
                        'Chi tiêu',
                        isExpense,
                        () => setState(() => isExpense = true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildTypeChip(
                        'Thu nhập',
                        !isExpense,
                        () => setState(() => isExpense = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Color selector
                Text('Màu sắc', style: AppTypography.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: colors.asMap().entries.map((entry) {
                    final isSelected = selectedColorIndex == entry.key;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedColorIndex = entry.key),
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
                Text('Icon', style: AppTypography.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: icons.asMap().entries.map((entry) {
                    final isSelected = selectedIconIndex == entry.key;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedIconIndex = entry.key),
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
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  return;
                }
                final repo = context.read<TransactionRepository>();
                await repo.addCategory(
                  name: nameController.text.trim(),
                  iconCode: icons[selectedIconIndex].codePoint,
                  colorValue: colors[selectedColorIndex],
                  isExpense: isExpense,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã thêm danh mục')),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, bool isSelected, VoidCallback onTap) {
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

  void _showDeleteCategoryDialog(BuildContext context, dynamic category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Xóa danh mục?'),
        content: Text('Bạn có chắc muốn xóa "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              final repo = context.read<TransactionRepository>();
              await repo.deleteCategory(category.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa danh mục')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
