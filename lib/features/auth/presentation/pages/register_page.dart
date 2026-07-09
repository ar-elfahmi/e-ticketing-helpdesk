import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_form_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final isSuccess = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Daftar gagal.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          authProvider.successMessage ?? 'Registrasi berhasil.',
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: AuthFormWidget(
                title: 'Buat akun baru',
                subtitle: 'Lengkapi data berikut untuk registrasi.',
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        label: 'Nama lengkap',
                        prefixIcon: Icons.badge_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }
                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _usernameController,
                        label: 'Username',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscure,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _confirmController,
                        label: 'Konfirmasi Password',
                        prefixIcon: Icons.lock_reset_outlined,
                        obscureText: _obscure,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Konfirmasi password tidak sama';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          label: AppStrings.register,
                          onPressed: _submit,
                          isLoading: isLoading,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Sudah punya akun?'),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Masuk'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
