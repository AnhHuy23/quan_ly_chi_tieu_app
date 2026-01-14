import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/locale/locale_provider.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import 'widgets/settings_widgets.dart';
import 'category_management_screen.dart';
import 'dialogs/danger_zone_dialogs.dart';

/// Settings Screen - Màn hình cài đặt (Refactored)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LocaleProvider>().strings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(strings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Language section
          SettingSectionHeader(title: strings.language),
          _buildLanguageCard(context),
          const SizedBox(height: AppSpacing.lg),

          // Account section
          SettingSectionHeader(title: strings.account),
          SettingCard(
            children: [
              SettingItem(
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                title: strings.personalInfo,
                subtitle: strings.nameAvatar,
                onTap: () => _showComingSoon(context, strings),
              ),
              const SettingDivider(),
              SettingItem(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.warning,
                title: strings.notifications,
                subtitle: strings.expenseReminders,
                onTap: () => _showComingSoon(context, strings),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Data section
          SettingSectionHeader(title: strings.data),
          SettingCard(
            children: [
              SettingItem(
                icon: Icons.category_outlined,
                iconColor: AppColors.secondary,
                title: strings.categoryManagement,
                subtitle: strings.addEditDeleteCategories,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategoryManagementScreen(),
                  ),
                ),
              ),
              const SettingDivider(),
              SettingItem(
                icon: Icons.download_outlined,
                iconColor: AppColors.income,
                title: strings.exportData,
                subtitle: strings.exportCSVExcel,
                onTap: () => _showComingSoon(context, strings),
              ),
              const SettingDivider(),
              SettingItem(
                icon: Icons.upload_outlined,
                iconColor: AppColors.info,
                title: strings.importData,
                subtitle: strings.importFromFile,
                onTap: () => _showComingSoon(context, strings),
              ),
              const SettingDivider(),
              SettingItem(
                icon: Icons.cloud_outlined,
                iconColor: AppColors.primary,
                title: strings.cloudBackup,
                subtitle: strings.syncGoogleDrive,
                onTap: () => _showComingSoon(context, strings),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Danger zone
          SettingSectionHeader(title: strings.dangerZone),
          SettingCard(
            children: [
              SettingItem(
                icon: Icons.delete_forever_outlined,
                iconColor: AppColors.error,
                title: strings.deleteAllTransactions,
                subtitle: strings.cannotUndo,
                onTap: () => showDeleteAllTransactionsDialog(context),
              ),
              const SettingDivider(),
              SettingItem(
                icon: Icons.refresh_outlined,
                iconColor: AppColors.warning,
                title: strings.resetApp,
                subtitle: strings.resetToDefault,
                onTap: () => showResetAppDialog(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // About section
          SettingSectionHeader(title: strings.info),
          SettingCard(
            children: [
              SettingItem(
                icon: Icons.info_outline,
                iconColor: AppColors.textSecondary,
                title: strings.version,
                subtitle: '1.0.0',
                onTap: null,
              ),
              const SettingDivider(),
              SettingItem(
                icon: Icons.star_outline,
                iconColor: AppColors.warning,
                title: strings.rateApp,
                subtitle: strings.giveUs5Stars,
                onTap: () => _showComingSoon(context, strings),
              ),
              const SettingDivider(),
              SettingItem(
                icon: Icons.help_outline,
                iconColor: AppColors.info,
                title: strings.support,
                subtitle: strings.sendFeedback,
                onTap: () => _showComingSoon(context, strings),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Quick Stats
          _buildQuickStatsCard(context, strings),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final strings = localeProvider.strings;
    final currentLanguage = localeProvider.currentLanguage;

    return SettingCard(
      children: [
        SettingItem(
          icon: Icons.language,
          iconColor: AppColors.primary,
          title: strings.language,
          subtitle: '${currentLanguage.flag} ${currentLanguage.name}',
          onTap: () => _showLanguageSelector(context),
        ),
      ],
    );
  }

  Widget _buildQuickStatsCard(BuildContext context, AppStrings strings) {
    return Consumer<TransactionRepository>(
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
                strings.quickStats,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  QuickStat(
                    label: strings.transactions,
                    value: '${repo.transactions.length}',
                  ),
                  QuickStat(
                    label: strings.balance,
                    value: CurrencyFormatter.formatCompact(repo.totalBalance),
                  ),
                  QuickStat(
                    label: strings.category,
                    value: '${repo.categories.length}',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();
    final strings = localeProvider.strings;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(strings.selectLanguage, style: AppTypography.heading3),
                const SizedBox(height: AppSpacing.md),
                ...AppLanguage.values.map((language) {
                  final isSelected = localeProvider.currentLanguage == language;
                  return ListTile(
                    onTap: () {
                      localeProvider.changeLanguage(language);
                      Navigator.pop(ctx);
                    },
                    leading: Text(
                      language.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      language.name,
                      style: AppTypography.bodyLarge.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mediumRadius,
                    ),
                    tileColor: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : null,
                  );
                }),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showComingSoon(BuildContext context, AppStrings strings) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.comingSoon),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
