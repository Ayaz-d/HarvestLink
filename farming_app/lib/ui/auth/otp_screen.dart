import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../nav.dart';
import '../../theme.dart';

class OtpScreen extends StatefulWidget {
  final String name;

  const OtpScreen({super.key, this.name = ''});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  void _verify() {
    if (_otpController.text.isEmpty) return;
    setState(() => _isLoading = true);
    
    // mock network delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.read<AppState>().verifyOtp(_otpController.text, widget.name);
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                'Verify Phone',
                style: context.textStyles.displaySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter the 4-digit code sent to your phone number.',
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP Code',
                  hintText: 'e.g. 1234',
                  prefixIcon: const Icon(Icons.security_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: context.textStyles.headlineMedium?.copyWith(letterSpacing: 8),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _isLoading ? null : _verify,
                style: FilledButton.styleFrom(
                  padding: AppSpacing.paddingLg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify & Proceed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
