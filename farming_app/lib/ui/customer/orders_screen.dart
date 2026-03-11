import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final orders = state.orders;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: colorScheme.outline.withOpacity(0.5)),
                  const SizedBox(height: AppSpacing.md),
                  Text('No orders yet', style: context.textStyles.titleLarge),
                ],
              ),
            )
          : ListView.builder(
              padding: AppSpacing.paddingLg,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _OrderCard(order: order),
                );
              },
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final AppOrder order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateStr = DateFormat('MMM dd, yyyy • hh:mm a').format(order.date);

    Color statusColor;
    String statusText;
    switch (order.status) {
      case OrderStatus.pending:
        statusColor = Colors.grey;
        statusText = 'Pending';
        break;
      case OrderStatus.processing:
        statusColor = Colors.orange;
        statusText = 'Processing';
        break;
      case OrderStatus.shipped:
        statusColor = Colors.blue;
        statusText = 'Shipped';
        break;
      case OrderStatus.delivered:
        statusColor = colorScheme.primary;
        statusText = 'Delivered';
        break;
    }

    return Card(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
            const SizedBox(height: AppSpacing.sm),
            Text(
              dateStr,
              style: context.textStyles.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const Divider(height: AppSpacing.xl),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity} kg x ${item.product.name}',
                          style: context.textStyles.bodyMedium,
                        ),
                      ),
                      Text(
                        '₹${item.totalPrice.toStringAsFixed(0)}',
                        style: context.textStyles.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            const Divider(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${order.totalPrice.toStringAsFixed(0)}',
                  style: context.textStyles.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.tonal(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order tracking available after shipping')),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_rounded, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Text('Track Order'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
