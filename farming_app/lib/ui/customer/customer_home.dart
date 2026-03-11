import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../nav.dart';
import '../../theme.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final _categories = ['All', 'Fruits', 'Vegetables', 'Grains', 'Nuts'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;

    List<Product> displayedProducts = state.products.where((p) {
      final matchesQuery = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${state.currentUser?.name ?? 'Customer'}',
              style: context.textStyles.titleLarge?.copyWith(color: colorScheme.primary),
            ),
            Text(
              'Fresh produce directly to your door',
              style: context.textStyles.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => state.logout(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search fresh farm products...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = cat == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) setState(() => _selectedCategory = cat);
                            },
                            selectedColor: colorScheme.primaryContainer,
                            labelStyle: TextStyle(
                              color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: AppSpacing.horizontalLg,
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = displayedProducts[index];
                  return _CustomerProductCard(product: product);
                },
                childCount: displayedProducts.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xxl * 2)),
        ],
      ),
    );
  }
}

class _CustomerProductCard extends StatelessWidget {
  final Product product;
  const _CustomerProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.productDetail, extra: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                    ),
                    width: double.infinity,
                    child: product.imageUrl.isNotEmpty
                        ? Image.asset(product.imageUrl, fit: BoxFit.contain)
                        : const Icon(Icons.image_not_supported_rounded, size: 40, color: Colors.grey),
                  ),
                  if (product.isRare)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          'Rare',
                          style: context.textStyles.labelSmall?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: AppSpacing.paddingSm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: context.textStyles.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${product.pricePerKg.toStringAsFixed(0)} / kg',
                    style: context.textStyles.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (product.totalQuantity <= 0)
                    Text(
                      'Out of Stock',
                      style: context.textStyles.labelSmall?.copyWith(color: colorScheme.error),
                    )
                  else
                    Text(
                      '${product.totalQuantity.toStringAsFixed(0)} kg available',
                      style: context.textStyles.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
