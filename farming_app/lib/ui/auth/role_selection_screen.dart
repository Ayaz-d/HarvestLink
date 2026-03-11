import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models.dart';
import '../../nav.dart';
import '../../theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: Icon(
                  Icons.eco_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Welcome to HarvestLink',
                textAlign: TextAlign.center,
                style: context.textStyles.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Please select your role to continue',
                textAlign: TextAlign.center,
                style: context.textStyles.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              _RoleCard(
                title: 'I am a Farmer',
                description: 'Sell your produce directly to the marketplace.',
                icon: Icons.agriculture_rounded,
                onTap: () {
                  context.push(AppRoutes.login, extra: UserRole.farmer);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _RoleCard(
                title: 'I am a Customer',
                description: 'Buy fresh produce from local farmers.',
                icon: Icons.shopping_basket_rounded,
                onTap: () {
                  context.push(AppRoutes.login, extra: UserRole.customer);
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        padding: AppSpacing.paddingLg,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: colorScheme.primaryContainer, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colorScheme.onPrimaryContainer, size: 32),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
