import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:e_ticketing_helpdesk/app.dart';
import 'package:e_ticketing_helpdesk/core/constants/app_strings.dart';
import 'package:e_ticketing_helpdesk/core/theme/theme_provider.dart';
import 'package:e_ticketing_helpdesk/features/auth/data/repositories/dummy_auth_repository.dart';
import 'package:e_ticketing_helpdesk/features/auth/presentation/providers/auth_provider.dart';
import 'package:e_ticketing_helpdesk/features/dashboard/data/repositories/dummy_dashboard_repository.dart';
import 'package:e_ticketing_helpdesk/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:e_ticketing_helpdesk/features/notification/data/repositories/dummy_notification_repository.dart';
import 'package:e_ticketing_helpdesk/features/notification/presentation/providers/notification_provider.dart';
import 'package:e_ticketing_helpdesk/features/profile/data/repositories/dummy_profile_repository.dart';
import 'package:e_ticketing_helpdesk/features/profile/presentation/providers/profile_provider.dart';
import 'package:e_ticketing_helpdesk/features/ticket/data/repositories/dummy_ticket_repository.dart';
import 'package:e_ticketing_helpdesk/features/ticket/presentation/providers/ticket_provider.dart';

void main() {
  testWidgets('App boots to login flow', (WidgetTester tester) async {
    final authRepository = DummyAuthRepository();
    final ticketRepository = DummyTicketRepository();
    final dashboardRepository = DummyDashboardRepository(
      ticketRepository: ticketRepository,
    );
    final notificationRepository = DummyNotificationRepository();
    final profileRepository = DummyProfileRepository(
      authRepository: authRepository,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(
            create: (_) => AuthProvider(authRepository: authRepository),
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
            create: (_) =>
                ProfileProvider(profileRepository: profileRepository),
          ),
        ],
        child: const App(initialRoute: AppRoutes.splash),
      ),
    );

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Masuk'), findsAtLeastNWidgets(1));
  });
}
