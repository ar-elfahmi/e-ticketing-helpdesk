import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _listenForRecovery();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  StreamSubscription<AuthState>? _recoverySub;

  void _listenForRecovery() {
    try {
      _recoverySub = Supabase.instance.client.auth.onAuthStateChange.listen(
        (data) {
          if (data.event == AuthChangeEvent.passwordRecovery) {
            if (context.mounted) {
              context.read<AuthProvider>().setRecoveryFlow();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.resetPassword,
              );
            }
          }
        },
      );
    } catch (_) {
      // Supabase is not initialized (e.g. in widget tests), ignore recovery listener
    }
  }

  Future<void> _bootstrap() async {
    if (_isRecoveryUri(Uri.base)) {
      if (!mounted) return;
      context.read<AuthProvider>().setRecoveryFlow();
      Navigator.of(context).pushReplacementNamed(AppRoutes.resetPassword);
      return;
    }

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (_isRecoveryUri(Uri.base)) {
      context.read<AuthProvider>().setRecoveryFlow();
      Navigator.of(context).pushReplacementNamed(AppRoutes.resetPassword);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await authProvider.bootstrap();

    if (!mounted) return;

    if (_isRecoveryUri(Uri.base) || authProvider.isRecoveryFlow) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.resetPassword);
      return;
    }

    Navigator.of(context).pushReplacementNamed(
      authProvider.isAuthenticated ? AppRoutes.shell : AppRoutes.login,
    );
  }

  bool _isRecoveryUri(Uri uri) {
    if (uri.pathSegments.contains('reset-password')) {
      return true;
    }

    if (uri.queryParameters['type'] == 'recovery' ||
        uri.queryParameters.containsKey('access_token') ||
        uri.queryParameters.containsKey('refresh_token')) {
      return true;
    }

    final fragment = uri.fragment;
    if (fragment.contains('reset-password') ||
        fragment.contains('type=recovery') ||
        fragment.contains('access_token=') ||
        fragment.contains('refresh_token=')) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    _recoverySub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.authGradientStart, AppColors.authGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.support_agent, color: Colors.white, size: 84),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
