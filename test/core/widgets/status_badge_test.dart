import 'package:e_ticketing_helpdesk/core/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('StatusBadge renders provided status text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StatusBadge(status: 'Open')),
      ),
    );

    expect(find.text('Open'), findsOneWidget);
  });
}
