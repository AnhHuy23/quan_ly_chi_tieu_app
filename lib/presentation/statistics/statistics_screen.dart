import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/transaction_repository_impl.dart';

/// Statistics Screen - Màn hình thống kê
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionRepository>(
      builder: (context, repo, _) {
        return SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Thống kê', style: AppTypography.heading2),
                    // Month selector
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.largeRadius,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: repo.previousMonth,
                            child: const Icon(
                              Icons.chevron_left,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'T${repo.selectedMonth.month}/${repo.selectedMonth.year}',
                            style: AppTypography.bodyMedium,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          GestureDetector(
                            onTap: repo.nextMonth,
                            child: const Icon(
                              Icons.chevron_right,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tab bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.largeRadius,
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppRadius.mediumRadius,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Chi tiêu'),
                    Tab(text: 'Thu nhập'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildExpenseStats(repo), _buildIncomeStats(repo)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpenseStats(TransactionRepository repo) {
    final expenseByCategory = repo.getExpenseByCategory();
    final totalExpense = repo.totalExpense;

    if (expenseByCategory.isEmpty) {
      return _buildEmptyState('chi tiêu');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          // Summary card
          _buildSummaryCard(
            title: 'Tổng chi tiêu',
            amount: totalExpense,
            color: AppColors.expense,
            icon: Icons.arrow_upward_rounded,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Pie chart
          _buildPieChart(expenseByCategory, totalExpense),
          const SizedBox(height: AppSpacing.lg),

          // Category breakdown
          _buildCategoryBreakdown(expenseByCategory, totalExpense),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildIncomeStats(TransactionRepository repo) {
    final totalIncome = repo.totalIncome;

    if (totalIncome == 0) {
      return _buildEmptyState('thu nhập');
    }

    // Calculate income by category
    final incomeByCategory = <CategoryModel, double>{};
    for (final t in repo.transactions.where((t) => !t.isExpense)) {
      final category = repo.getCategoryById(t.categoryId);
      if (category != null) {
        incomeByCategory[category] =
            (incomeByCategory[category] ?? 0) + t.amount;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          // Summary card
          _buildSummaryCard(
            title: 'Tổng thu nhập',
            amount: totalIncome,
            color: AppColors.income,
            icon: Icons.arrow_downward_rounded,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Pie chart
          _buildPieChart(incomeByCategory, totalIncome),
          const SizedBox(height: AppSpacing.lg),

          // Category breakdown
          _buildCategoryBreakdown(incomeByCategory, totalIncome),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.extraLargeRadius,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(amount),
                style: AppTypography.heading2.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(Map<CategoryModel, double> data, double total) {
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.extraLargeRadius,
      ),
      child: Row(
        children: [
          // Chart
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: entries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value.key;
                  final value = entry.value.value;
                  final percentage = (value / total * 100);
                  final isTouched = index == _touchedIndex;

                  return PieChartSectionData(
                    color: Color(category.colorValue),
                    value: value,
                    title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
                    radius: isTouched ? 50 : 40,
                    titleStyle: AppTypography.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Legend
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.take(5).map((entry) {
              final category = entry.key;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(category.colorValue),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(category.name, style: AppTypography.caption),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(
    Map<CategoryModel, double> data,
    double total,
  ) {
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Chi tiết theo danh mục', style: AppTypography.heading3),
        const SizedBox(height: AppSpacing.md),
        ...entries.map((entry) {
          final category = entry.key;
          final amount = entry.value;
          final percentage = total > 0 ? (amount / total) : 0.0;
          final color = Color(category.colorValue);

          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: AppRadius.smallRadius,
                      ),
                      child: Icon(
                        IconData(
                          category.iconCode,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.name, style: AppTypography.bodyLarge),
                          Text(
                            '${(percentage * 100).toStringAsFixed(1)}%',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(amount),
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Chưa có dữ liệu $type',
            style: AppTypography.heading3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Thêm giao dịch để xem thống kê',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
