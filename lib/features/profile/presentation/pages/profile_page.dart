import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_menu_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user == null) {
        return;
      }
      context.read<ProfileProvider>().fetchProfile(user.id);
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) {
      return;
    }

    await context.read<AuthProvider>().logout();

    if (!mounted) {
      return;
    }

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthProvider>().currentUser;
    final profileUser = context.watch<ProfileProvider>().userProfile;
    final themeProvider = context.watch<ThemeProvider>();

    final user = profileUser ?? authUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? '?',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '-',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(user?.email ?? '-'),
                        const SizedBox(height: 4),
                        Chip(label: Text(user?.role.displayName ?? '-')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ProfileMenuItem(
            title: 'Edit Profil',
            icon: Icons.edit_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur akan segera hadir.')),
              );
            },
          ),
          ProfileMenuItem(
            title: 'Ubah Password',
            icon: Icons.password_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur akan segera hadir.')),
              );
            },
          ),
          if (authUser?.role == UserRole.admin)
            ProfileMenuItem(
              title: 'Kelola User',
              icon: Icons.people_outline,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.adminManageUsers);
              },
            ),
          ProfileMenuItem(
            title: 'Dark Mode',
            icon: Icons.dark_mode_outlined,
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.toggleTheme,
            ),
          ),
          ProfileMenuItem(
            title: 'Tentang Aplikasi',
            icon: Icons.info_outline,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'E-Ticketing Helpdesk',
                applicationVersion: '1.0.0',
                children: const [
                  Text(
                    'Aplikasi dummy e-ticketing helpdesk berbasis Flutter + Provider.',
                  ),
                ],
              );
            },
          ),
          const Divider(height: 24),
          ProfileMenuItem(
            title: 'Keluar',
            icon: Icons.logout,
            color: Colors.red,
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
