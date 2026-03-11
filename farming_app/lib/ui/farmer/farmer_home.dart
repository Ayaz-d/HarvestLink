import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme.dart';
import 'sell_product_sheet.dart';

class FarmerHome extends StatefulWidget {
  const FarmerHome({super.key});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final _categories = ['All', 'Fruits', 'Vegetables', 'Grains', 'Nuts'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;

    // Filter products
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
              'Hello, ${state.currentUser?.name ?? 'Farmer'} 👋',
              style: context.textStyles.titleLarge?.copyWith(color: colorScheme.primary),
            ),
            Text(
              'Sell your produce today',
              style: context.textStyles.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            tooltip: 'Toggle Language',
            onPressed: () {
              state.toggleLanguage();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.isKannada ? 'Language changed to Kannada' : 'Language changed to English'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
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
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: state.isKannada ? 'ಉತ್ಪನ್ನಗಳನ್ನು ಹುಡುಕಿ...' : 'Search market prices...',
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

                  // Categories
                  Text(
                    state.isKannada ? 'ವರ್ಗಗಳು' : 'Categories',
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
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
                  Text(
                    state.isKannada ? 'ಮಾರುಕಟ್ಟೆ ಬೆಲೆಗಳು' : 'Current Market Prices',
                    style: context.textStyles.titleMedium,
                  ),
                ],
              ),
            ),
          ),

          // Product Grid
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
                  return _ProductCard(product: product);
                },
                childCount: displayedProducts.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xxl * 2)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const SellProductSheet(),
          );
        },
        icon: const Icon(Icons.add_business_rounded),
        label: Text(state.isKannada ? 'ಮಾರಾಟ ಮಾಡಿ' : 'Sell to Gov'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
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
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              ),
              child: product.imageUrl.isNotEmpty
                  ? Image.asset(product.imageUrl, fit: BoxFit.contain)
                  : const Icon(Icons.image_not_supported_rounded, size: 40, color: Colors.grey),
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
                  product.category,
                  style: context.textStyles.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '₹${product.pricePerKg.toStringAsFixed(0)} / kg',
                  style: context.textStyles.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
