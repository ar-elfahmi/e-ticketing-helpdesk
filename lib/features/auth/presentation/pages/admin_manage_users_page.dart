import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/data/models/user_model.dart';
import '../providers/auth_provider.dart';

class AdminManageUsersPage extends StatefulWidget {
  const AdminManageUsersPage({super.key});

  @override
  State<AdminManageUsersPage> createState() => _AdminManageUsersPageState();
}

class _AdminManageUsersPageState extends State<AdminManageUsersPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      authProvider.fetchUsers();
      authProvider.fetchDeletedUsers();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await context.read<AuthProvider>().registerHelpdesk(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat akun helpdesk.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Akun helpdesk berhasil dibuat.')),
    );
    _nameController.clear();
    _emailController.clear();
    _usernameController.clear();
    _passwordController.clear();

    await context.read<AuthProvider>().fetchUsers();
  }

  Future<void> _deleteUser(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus user?'),
        content: Text(
          'User ${user.name} akan dinonaktifkan dan tidak akan tampil di daftar aktif.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final ok = await context.read<AuthProvider>().deleteUser(user.id);
    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus user.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.name} berhasil dihapus.')),
    );
  }

  Future<void> _restoreUser(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pulihkan user?'),
        content: Text(
          'User ${user.name} akan dikembalikan ke daftar aktif.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Pulihkan'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final ok = await context.read<AuthProvider>().restoreUser(user.id);
    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memulihkan user.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.name} berhasil dipulihkan.')),
    );
  }

  String _roleLabel(UserRole role) {
    return switch (role) {
      UserRole.user => 'User',
      UserRole.helpdesk => 'Helpdesk',
      UserRole.admin => 'Admin',
    };
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;
    final isLoadingUsers = authProvider.isLoadingUsers;
    final isLoadingDeletedUsers = authProvider.isLoadingDeletedUsers;
    final users = authProvider.users;
    final deletedUsers = authProvider.deletedUsers;
    final currentUser = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola User')),
      body: RefreshIndicator(
        onRefresh: () => context.read<AuthProvider>().fetchUsers(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buat Akun Helpdesk',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _nameController,
                        label: 'Nama Lengkap',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!v.contains('@')) return 'Email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _usernameController,
                        label: 'Username',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Username wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          if (v.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: 'Buat Akun Helpdesk',
                        onPressed: _submit,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar User',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text('${users.length} akun'),
              ],
            ),
            const SizedBox(height: 12),
            if (isLoadingUsers && users.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (users.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('Belum ada user.')),
                ),
              )
            else
              ...users.map(
                (user) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user.name.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(user.name),
                    subtitle: Text('${user.email}\n@${user.username}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(label: Text(_roleLabel(user.role))),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Hapus user',
                          onPressed: currentUser?.id == user.id
                              ? null
                              : () => _deleteUser(user),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Nonaktif',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text('${deletedUsers.length} akun'),
              ],
            ),
            const SizedBox(height: 12),
            if (isLoadingDeletedUsers && deletedUsers.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (deletedUsers.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('Belum ada user nonaktif.')),
                ),
              )
            else
              ...deletedUsers.map(
                (user) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      child: Text(user.name.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(user.name),
                    subtitle: Text(
                      '${user.email}\n@${user.username}'
                      '${user.deletedBy != null ? '\nDihapus oleh: ${user.deletedBy}' : ''}',
                    ),
                    isThreeLine: true,
                    trailing: FilledButton.tonalIcon(
                      onPressed: () => _restoreUser(user),
                      icon: const Icon(Icons.restore),
                      label: const Text('Pulihkan'),
                    ),
                  ),
                ),
              ),
            if (authProvider.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                authProvider.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
