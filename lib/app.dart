import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/services/navigation_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/pages/admin_manage_users_page.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/dashboard/presentation/pages/app_shell_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/notification/presentation/pages/notification_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/ticket/presentation/pages/admin_manage_tickets_page.dart';
import 'features/ticket/presentation/pages/create_ticket_page.dart';
import 'features/ticket/presentation/pages/ticket_detail_page.dart';
import 'features/ticket/presentation/pages/ticket_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: AppStrings.appName,
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (_) => const SplashPage(),
            AppRoutes.login: (_) => const LoginPage(),
            AppRoutes.register: (_) => const RegisterPage(),
            AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
            AppRoutes.shell: (_) => const AppShellPage(),
            AppRoutes.dashboard: (_) => const DashboardPage(),
            AppRoutes.ticketList: (_) => const TicketListPage(),
            AppRoutes.createTicket: (_) => const CreateTicketPage(),
            AppRoutes.notification: (_) => const NotificationPage(),
            AppRoutes.profile: (_) => const ProfilePage(),
            AppRoutes.adminManageUsers: (_) => const AdminManageUsersPage(),
            AppRoutes.adminManageTickets: (_) => const AdminManageTicketsPage(),
          },
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.ticketDetail) {
      final args = settings.arguments;
      final ticketId = switch (args) {
        String value => value,
        {'ticketId': final String value} => value,
        _ => null,
      };

      if (ticketId != null) {
        return MaterialPageRoute(
          builder: (_) => TicketDetailPage(ticketId: ticketId),
          settings: settings,
        );
      }
    }

    return MaterialPageRoute(
      builder: (_) => const _UnknownRoutePage(),
      settings: settings,
    );
  }
}

class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Route tidak ditemukan.')));
  }
}
