import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSessionReady = false;
  bool _isCheckingSession = true;
  String? _sessionError;

  @override
  void initState() {
    super.initState();
    _listenForRecovery();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecoverySession();
    });
  }

  StreamSubscription<AuthState>? _recoverySub;

  void _listenForRecovery() {
    _recoverySub = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        if (data.event == AuthChangeEvent.passwordRecovery && _isCheckingSession) {
          if (context.mounted) {
            context.read<AuthProvider>().setRecoveryFlow();
          }
          _retrySession();
        }
      },
    );
  }

  @override
  void dispose() {
    _recoverySub?.cancel();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _retrySession() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.bootstrap();

    if (!mounted) return;

    if (authProvider.currentUser != null) {
      setState(() {
        _isSessionReady = true;
        _sessionError = null;
        _isCheckingSession = false;
      });
    }
  }

  Future<void> _loadRecoverySession() async {
    final authProvider = context.read<AuthProvider>();

    if (authProvider.isRecoveryFlow || _isRecoveryUri(Uri.base)) {
      authProvider.setRecoveryFlow();
    }

    await authProvider.bootstrap();

    if (!mounted) return;

    if (authProvider.currentUser != null) {
      setState(() {
        _isSessionReady = true;
        _isCheckingSession = false;
      });
      return;
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    await authProvider.bootstrap();

    if (!mounted) return;

    setState(() {
      _isSessionReady = authProvider.currentUser != null;
      _sessionError = _isSessionReady
          ? null
          : AppStrings.resetPasswordInvalidLink;
      _isCheckingSession = false;
    });
  }

  bool _isRecoveryUri(Uri uri) {
    if (uri.pathSegments.contains('reset-password')) return true;
    if (uri.queryParameters['type'] == 'recovery' ||
        uri.queryParameters.containsKey('access_token') ||
        uri.queryParameters.containsKey('refresh_token')) return true;
    final fragment = uri.fragment;
    if (fragment.contains('reset-password') ||
        fragment.contains('type=recovery') ||
        fragment.contains('access_token=') ||
        fragment.contains('refresh_token=')) return true;
    return false;
  }

  Future<void> _submit() async {
    if (!_isSessionReady || !_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final isSuccess = await authProvider.updatePassword(
      _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? AppStrings.resetPasswordInvalidLink),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await authProvider.logout();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.resetPasswordSuccess),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  String? _validatePassword(String? value) {
    final password = value?.trim() ?? '';
    if (password.isEmpty) {
      return 'Password baru wajib diisi';
    }
    if (password.length < 8) {
      return AppStrings.newPasswordMinLength;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final confirmPassword = value?.trim() ?? '';
    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (confirmPassword != _passwordController.text) {
      return AppStrings.newPasswordMismatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Stack(
          children: [
            const _ResetHeaderBand(),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.password_rounded,
                          color: AppColors.primary,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Reset Password',
                        style: textTheme.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.resetPasswordTitle,
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 36,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                          child: _isCheckingSession
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.resetPasswordTitle,
                                        style: textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        AppStrings.resetPasswordHint,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: AppColors.textLight.withValues(alpha: 0.78),
                                          fontWeight: FontWeight.w600,
                                          height: 1.35,
                                        ),
                                      ),
                                      if (_sessionError != null) ...[
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF3F3),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: const Color(0xFFFFD0D0),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.info_outline_rounded,
                                                color: Color(0xFFB42318),
                                                size: 18,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  _sessionError!,
                                                  style: textTheme.bodyMedium?.copyWith(
                                                    color: const Color(0xFFB42318),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ] else ...[
                                        const SizedBox(height: 22),
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          decoration: InputDecoration(
                                            labelText: AppStrings.newPassword,
                                            hintText: 'Masukkan password baru',
                                            filled: true,
                                            fillColor: const Color(0xFFF9FBFF),
                                            prefixIcon: const Icon(Icons.lock_outline),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _obscurePassword = !_obscurePassword;
                                                });
                                              },
                                              icon: Icon(
                                                _obscurePassword
                                                    ? Icons.visibility_outlined
                                                    : Icons.visibility_off_outlined,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: BorderSide(
                                                color: AppColors.textLight.withValues(alpha: 0.15),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: BorderSide(
                                                color: AppColors.textLight.withValues(alpha: 0.15),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: const BorderSide(
                                                color: AppColors.primary,
                                                width: 1.4,
                                              ),
                                            ),
                                          ),
                                          validator: _validatePassword,
                                        ),
                                        const SizedBox(height: 14),
                                        TextFormField(
                                          controller: _confirmPasswordController,
                                          obscureText: _obscureConfirmPassword,
                                          decoration: InputDecoration(
                                            labelText: AppStrings.confirmNewPassword,
                                            hintText: 'Ulangi password baru',
                                            filled: true,
                                            fillColor: const Color(0xFFF9FBFF),
                                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                                });
                                              },
                                              icon: Icon(
                                                _obscureConfirmPassword
                                                    ? Icons.visibility_outlined
                                                    : Icons.visibility_off_outlined,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: BorderSide(
                                                color: AppColors.textLight.withValues(alpha: 0.15),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: BorderSide(
                                                color: AppColors.textLight.withValues(alpha: 0.15),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(14),
                                              borderSide: const BorderSide(
                                                color: AppColors.primary,
                                                width: 1.4,
                                              ),
                                            ),
                                          ),
                                          validator: _validateConfirmPassword,
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          child: CustomButton(
                                            label: AppStrings.resetPassword,
                                            icon: Icons.save_rounded,
                                            onPressed: _submit,
                                            isLoading: isLoading,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      Center(
                                        child: TextButton(
                                          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                                            AppRoutes.login,
                                            (route) => false,
                                          ),
                                          child: const Text('Kembali ke Login'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResetHeaderBand extends StatelessWidget {
  const _ResetHeaderBand();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(48)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B6BCB), Color(0xFF3092ED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(left: -28, top: 18, child: _BlurCircle(size: 130)),
              Positioned(right: 22, top: -34, child: _BlurCircle(size: 122)),
              Positioned(right: -34, bottom: 18, child: _BlurCircle(size: 145)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.13),
      ),
    );
  }
}
