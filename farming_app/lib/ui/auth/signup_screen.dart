import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models.dart';
import '../../data/app_state.dart';
import '../../nav.dart';
import '../../theme.dart';

class SignupScreen extends StatefulWidget {
  final UserRole role;

  const SignupScreen({super.key, required this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _signup() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) return;

    setState(() => _isLoading = true);
    await context.read<AppState>().login(
          _emailController.text,
          _passwordController.text,
          widget.role,
        );
    setState(() => _isLoading = false);

    if (mounted) {
      context.push(AppRoutes.otp, extra: _nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFarmer = widget.role == UserRole.farmer;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Create Account',
                style: context.textStyles.displaySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isFarmer ? 'Join our farmer community.' : 'Start buying fresh produce.',
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _isLoading ? null : _signup,
                style: FilledButton.styleFrom(
                  padding: AppSpacing.paddingLg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign Up'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: context.textStyles.bodyMedium?.copyWith(color: colorScheme.onSurface),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
