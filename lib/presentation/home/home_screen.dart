import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../statistics/statistics_screen.dart';
import 'widgets/balance_card.dart';
import 'widgets/transaction_list.dart';

/// Home Screen - Màn hình chính
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [_HomeTab(), StatisticsScreen()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransaction,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Trang chủ',
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              const SizedBox(width: 60), // Space for FAB
              _buildNavItem(
                icon: Icons.pie_chart_rounded,
                label: 'Thống kê',
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mediumRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTransaction() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );
  }
}

/// Home Tab Content
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionRepository>(
      builder: (context, repo, _) {
        if (repo.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: AppColors.background,
                title: Text('Quản lý chi tiêu', style: AppTypography.heading2),
                actions: [
                  IconButton(
                    onPressed: () {
                      // TODO: Settings
                    },
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),

              // Balance Card
              SliverToBoxAdapter(
                child: BalanceCard(
                  balance: repo.balance,
                  income: repo.totalIncome,
                  expense: repo.totalExpense,
                  monthYear: DateFormatter.formatMonthYear(repo.selectedMonth),
                  onPreviousMonth: repo.previousMonth,
                  onNextMonth: repo.nextMonth,
                ),
              ),

              // Section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Giao dịch', style: AppTypography.heading3),
                      Text(
                        '${repo.transactions.length} giao dịch',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),

              // Transaction List
              SliverToBoxAdapter(
                child: TransactionList(
                  transactionsByDate: repo.transactionsByDate,
                  getCategoryById: repo.getCategoryById,
                  onTransactionTap: (transaction) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddTransactionScreen(transaction: transaction),
                      ),
                    );
                  },
                  onTransactionDelete: (id) {
                    repo.deleteTransaction(id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã xóa giao dịch'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),

              // Bottom padding for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }
}
