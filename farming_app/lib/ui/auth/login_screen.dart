import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models.dart';
import '../../data/app_state.dart';
import '../../nav.dart';
import '../../theme.dart';

class LoginScreen extends StatefulWidget {
  final UserRole role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;

    setState(() => _isLoading = true);
    await context.read<AppState>().login(
          _emailController.text,
          _passwordController.text,
          widget.role,
        );
    setState(() => _isLoading = false);

    if (mounted) {
      context.push(AppRoutes.otp);
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
                'Welcome Back',
                style: context.textStyles.displaySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isFarmer ? 'Login to manage your farm.' : 'Login to buy fresh produce.',
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
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
                onPressed: _isLoading ? null : _login,
                style: FilledButton.styleFrom(
                  padding: AppSpacing.paddingLg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () {
                  context.push(AppRoutes.signup, extra: widget.role);
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: context.textStyles.bodyMedium?.copyWith(color: colorScheme.onSurface),
                    children: [
                      TextSpan(
                        text: 'Sign up',
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
