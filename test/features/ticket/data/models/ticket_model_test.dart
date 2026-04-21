import 'package:e_ticketing_helpdesk/features/ticket/data/models/ticket_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TicketModel json serialization roundtrip', () {
    final model = TicketModel(
      id: 't1',
      ticketNumber: 'TK-001',
      title: 'Test ticket',
      description: 'Testing ticket model',
      category: 'Software',
      priority: TicketPriority.high,
      status: TicketStatus.open,
      createdAt: DateTime(2026, 4, 19),
      updatedAt: DateTime(2026, 4, 19, 10),
      reporterId: 'u1',
      assigneeId: 'h1',
      attachments: const ['a.png'],
      history: [
        StatusHistory(
          status: TicketStatus.open,
          changedBy: 'System',
          changedAt: DateTime(2026, 4, 19),
        ),
      ],
    );

    final json = model.toJson();
    final restored = TicketModel.fromJson(json);

    expect(restored.id, model.id);
    expect(restored.ticketNumber, model.ticketNumber);
    expect(restored.history.length, 1);
  });
}
