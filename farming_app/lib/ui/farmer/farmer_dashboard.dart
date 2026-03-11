import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/app_state.dart';
import '../../theme.dart';
import '../../data/models.dart';

class FarmerDashboard extends StatelessWidget {
  const FarmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final history = state.sellingHistory;

    double totalEarnings = history.where((h) => h.status == SellingStatus.completed).fold(0, (sum, h) => sum + h.earnings);
    double pendingEarnings = history.where((h) => h.status != SellingStatus.completed).fold(0, (sum, h) => sum + h.earnings);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.isKannada ? 'ಡ್ಯಾಶ್ಬೋರ್ಡ್' : 'Dashboard'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    state.isKannada ? 'ಆದಾಯ ಸಾರಾಂಶ' : 'Earnings Summary',
                    style: context.textStyles.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _EarningsCard(
                          title: state.isKannada ? 'ಒಟ್ಟು ಆದಾಯ' : 'Total Earnings',
                          amount: totalEarnings,
                          color: colorScheme.primaryContainer,
                          onColor: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _EarningsCard(
                          title: state.isKannada ? 'ಬಾಕಿ ಮೊತ್ತ' : 'Pending',
                          amount: pendingEarnings,
                          color: colorScheme.surfaceVariant,
                          onColor: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    state.isKannada ? 'ಮಾರಾಟ ಇತಿಹಾಸ' : 'Selling History',
                    style: context.textStyles.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final record = history[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                  child: _HistoryTile(record: record),
                );
              },
              childCount: history.length,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xxl)),
        ],
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final Color onColor;

  const _EarningsCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyles.bodyMedium?.copyWith(color: onColor.withOpacity(0.8)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: context.textStyles.headlineMedium?.copyWith(
              color: onColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final SellingRecord record;

  const _HistoryTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateStr = DateFormat('MMM dd, yyyy').format(record.date);
    
    Color statusColor;
    String statusText;
    switch (record.status) {
      case SellingStatus.completed:
        statusColor = colorScheme.primary;
        statusText = 'Completed';
        break;
      case SellingStatus.accepted:
        statusColor = Colors.orange;
        statusText = 'Accepted';
        break;
      case SellingStatus.pendingVerification:
        statusColor = Colors.grey;
        statusText = 'Pending';
        break;
    }

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.paddingSm,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.receipt_long_rounded),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.product.name,
                  style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${record.quantitySold} kg • $dateStr',
                  style: context.textStyles.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${record.earnings.toStringAsFixed(0)}',
                style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  statusText,
                  style: context.textStyles.labelSmall?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
