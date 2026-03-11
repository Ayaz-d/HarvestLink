import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _increment() {
    if (_quantity < 50 && _quantity < widget.product.totalQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _addToCart() {
    final state = context.read<AppState>();
    final result = state.addToCart(widget.product, _quantity);
    
    if (result == 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $_quantity kg of ${widget.product.name} to cart')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Theme.of(context).colorScheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final p = widget.product;
    final isOutOfStock = p.totalQuantity <= 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 250,
                      color: colorScheme.surfaceVariant.withOpacity(0.5),
                      child: p.imageUrl.isNotEmpty
                          ? Image.asset(p.imageUrl, fit: BoxFit.contain)
                          : const Icon(Icons.image_not_supported_rounded, size: 80, color: Colors.grey),
                    ),
                    Padding(
                      padding: AppSpacing.paddingLg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                                child: Text(
                                  p.category,
                                  style: context.textStyles.labelSmall?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              if (p.isRare) ...[
                                const SizedBox(width: AppSpacing.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppRadius.sm),
                                  ),
                                  child: Text(
                                    'Rare Product',
                                    style: context.textStyles.labelSmall?.copyWith(
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            p.name,
                            style: context.textStyles.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '₹${p.pricePerKg.toStringAsFixed(0)} / kg',
                            style: context.textStyles.headlineSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            'Description',
                            style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Fresh ${p.name.toLowerCase()} sourced directly from verified farmers at ${p.pickupLocation}. High quality and government approved. Maximum purchase limit is 50kg per order.',
                            style: context.textStyles.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          if (!isOutOfStock) ...[
                            Text(
                              'Select Quantity',
                              style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_rounded),
                                        onPressed: _decrement,
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: Text(
                                          '$_quantity kg',
                                          textAlign: TextAlign.center,
                                          style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_rounded),
                                        onPressed: _increment,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    'Available: ${p.totalQuantity.toStringAsFixed(0)} kg',
                                    style: context.textStyles.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: isOutOfStock
                    ? FilledButton(
                        onPressed: null,
                        style: FilledButton.styleFrom(
                          padding: AppSpacing.paddingLg,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                        ),
                        child: const Text('Out of Stock'),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Total Price',
                                  style: context.textStyles.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                                Text(
                                  '₹${(p.pricePerKg * _quantity).toStringAsFixed(0)}',
                                  style: context.textStyles.titleLarge?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              onPressed: _addToCart,
                              style: FilledButton.styleFrom(
                                padding: AppSpacing.paddingLg,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                              ),
                              child: const Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
