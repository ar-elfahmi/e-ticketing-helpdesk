import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/constants/app_strings.dart';
import 'core/network/supabase_config.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/data/repositories/supabase_auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/data/repositories/dummy_dashboard_repository.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';
import 'features/notification/data/repositories/supabase_notification_repository.dart';
import 'features/notification/presentation/providers/notification_provider.dart';
import 'features/profile/data/repositories/supabase_profile_repository.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'features/ticket/data/repositories/supabase_ticket_repository.dart';
import 'features/ticket/presentation/providers/ticket_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  final initialRoute = _resolveInitialRoute();

  final supabaseAuthRepository = SupabaseAuthRepository();
  final ticketRepository = SupabaseTicketRepository();
  final dashboardRepository = DummyDashboardRepository(
    ticketRepository: ticketRepository,
  );
  final notificationRepository = SupabaseNotificationRepository();
  final profileRepository = SupabaseProfileRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authRepository: supabaseAuthRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketProvider(ticketRepository: ticketRepository),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              DashboardProvider(dashboardRepository: dashboardRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            notificationRepository: notificationRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(profileRepository: profileRepository),
        ),
      ],
      child: App(initialRoute: initialRoute),
    ),
  );
}

String _resolveInitialRoute() {
  final uri = Uri.base;
  if (_isRecoveryUri(uri)) {
    return AppRoutes.resetPassword;
  }

  return AppRoutes.splash;
}

bool _isRecoveryUri(Uri uri) {
  final pathMatches = uri.pathSegments.contains('reset-password');
  final queryMatches = uri.queryParameters['type'] == 'recovery' ||
      uri.queryParameters.containsKey('access_token') ||
      uri.queryParameters.containsKey('refresh_token');

  final fragmentUri = _parseFragmentUri(uri.fragment);
  final fragmentMatches = fragmentUri != null &&
      (_isRecoveryUri(fragmentUri) ||
          fragmentUri.pathSegments.contains('reset-password'));

  return pathMatches || queryMatches || fragmentMatches;
}

Uri? _parseFragmentUri(String fragment) {
  if (fragment.isEmpty) {
    return null;
  }

  final normalized = fragment.startsWith('/') ? fragment.substring(1) : fragment;
  if (normalized.isEmpty) {
    return null;
  }

  final fragmentText = normalized.startsWith('?')
      ? normalized.substring(1)
      : normalized;

  final hasQueryShape = fragmentText.contains('=');
  if (hasQueryShape) {
    return Uri(query: fragmentText);
  }

  return Uri.parse('https://local/$normalized');
}
