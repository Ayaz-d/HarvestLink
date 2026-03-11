import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../theme.dart';

class SellProductSheet extends StatefulWidget {
  const SellProductSheet({super.key});

  @override
  State<SellProductSheet> createState() => _SellProductSheetState();
}

class _SellProductSheetState extends State<SellProductSheet> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _category = 'Vegetables';
  double _pricePerKg = 0;
  double _quantity = 0;
  String _pickupLocation = '';

  final _categories = ['Fruits', 'Vegetables', 'Grains', 'Nuts'];

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    context.read<AppState>().sellProduct(
      name: _name,
      category: _category,
      pricePerKg: _pricePerKg,
      quantity: _quantity,
      pickupLocation: _pickupLocation,
    );

    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product submitted for verification.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKannada = context.read<AppState>().isKannada;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                isKannada ? 'ಸರ್ಕಾರಕ್ಕೆ ಮಾರು' : 'Sell to Government',
                style: context.textStyles.headlineSmall?.copyWith(color: colorScheme.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                decoration: InputDecoration(
                  labelText: isKannada ? 'ಉತ್ಪನ್ನದ ಹೆಸರು' : 'Product Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: isKannada ? 'ವರ್ಗ' : 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _category = val!),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: isKannada ? 'ಬೆಲೆ / ಕೆಜಿ (₹)' : 'Price per kg (₹)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null,
                      onSaved: (val) => _pricePerKg = double.parse(val!),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: isKannada ? 'ಪ್ರಮಾಣ (ಕೆಜಿ)' : 'Quantity (kg)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null,
                      onSaved: (val) => _quantity = double.parse(val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                decoration: InputDecoration(
                  labelText: isKannada ? 'ಪಿಕ್ ಅಪ್ ಸ್ಥಳ' : 'Pickup Location',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  prefixIcon: const Icon(Icons.location_on_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _pickupLocation = val!,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  padding: AppSpacing.paddingLg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                child: Text(isKannada ? 'ಸಲ್ಲಿಸಿ' : 'Submit for Verification'),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
