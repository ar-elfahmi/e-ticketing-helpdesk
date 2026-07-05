import 'dart:math';
import 'dart:typed_data';

import '../models/comment_model.dart';
import '../models/ticket_model.dart';
import 'ticket_repository.dart';

class DummyTicketRepository implements TicketRepository {
  DummyTicketRepository() {
    _seedData();
  }

  final List<TicketModel> _tickets = [];
  final Map<String, List<CommentModel>> _commentsByTicket = {};
  int _ticketCounter = 15;

  void _seedData() {
    final now = DateTime.now();
    final seeds = <Map<String, Object?>>[
      {
        'title': 'Printer lantai 2 tidak bisa cetak',
        'description':
            'Printer menampilkan kertas macet padahal tray kosong. Sudah restart perangkat.',
        'category': 'Hardware',
        'priority': TicketPriority.medium,
        'status': TicketStatus.open,
        'reporterId': 'u1',
        'assigneeId': 'h1',
        'daysAgo': 1,
      },
      {
        'title': 'Email kantor tidak menerima pesan eksternal',
        'description':
            'Sejak pagi email dari domain luar tidak masuk ke inbox tim marketing.',
        'category': 'Network',
        'priority': TicketPriority.high,
        'status': TicketStatus.inProgress,
        'reporterId': 'u1',
        'assigneeId': 'h1',
        'daysAgo': 2,
      },
      {
        'title': 'Aplikasi inventory force close saat buka laporan',
        'description':
            'Aplikasi tertutup sendiri setiap klik menu laporan bulanan di perangkat kasir.',
        'category': 'Software',
        'priority': TicketPriority.high,
        'status': TicketStatus.inProgress,
        'reporterId': 'u1',
        'assigneeId': 'h1',
        'daysAgo': 3,
      },
      {
        'title': 'Reset password akun ERP',
        'description':
            'User lupa password ERP dan tidak bisa akses approval pembelian.',
        'category': 'Software',
        'priority': TicketPriority.low,
        'status': TicketStatus.closed,
        'reporterId': 'u1',
        'assigneeId': 'h1',
        'daysAgo': 4,
      },
      {
        'title': 'WiFi meeting room sering putus',
        'description':
            'Koneksi WiFi putus tiap 10 menit saat meeting di ruang Garuda.',
        'category': 'Network',
        'priority': TicketPriority.medium,
        'status': TicketStatus.open,
        'reporterId': 'u1',
        'assigneeId': null,
        'daysAgo': 5,
      },
      {
        'title': 'Permintaan instalasi software desain',
        'description':
            'Laptop tim kreatif membutuhkan software desain terbaru untuk project klien.',
        'category': 'Software',
        'priority': TicketPriority.medium,
        'status': TicketStatus.open,
        'reporterId': 'u1',
        'assigneeId': null,
        'daysAgo': 6,
      },
      {
        'title': 'Monitor workstation berkedip',
        'description':
            'Monitor utama workstation finance berkedip dan kadang blank selama 2 detik.',
        'category': 'Hardware',
        'priority': TicketPriority.medium,
        'status': TicketStatus.inProgress,
        'reporterId': 'u1',
        'assigneeId': 'h1',
        'daysAgo': 7,
      },
      {
        'title': 'Akses folder server ditolak',
        'description':
            'Tim procurement tidak bisa membuka folder bersama di file server.',
        'category': 'Network',
        'priority': TicketPriority.high,
        'status': TicketStatus.closed,
        'reporterId': 'u1',
        'assigneeId': 'h1',
        'daysAgo': 8,
      },
      {
        'title': 'Keyboard laptop beberapa tombol tidak responsif',
        'description':
            'Tombol enter dan backspace pada laptop sales sering tidak berfungsi.',
        'category': 'Hardware',
        'priority': TicketPriority.low,
        'status': TicketStatus.open,
        'reporterId': 'u1',
        'assigneeId': null,
        'daysAgo': 9,
      },
      {
        'title': 'VPN gagal koneksi untuk kerja remote',
        'description':
            'Client VPN menampilkan authentication failed pada beberapa karyawan remote.',
        'category': 'Network',
        'priority': TicketPriority.critical,
        'status': TicketStatus.inProgress,
        'reporterId': 'u1',
        'assigneeId': 'a1',
        'daysAgo': 10,
      },
      {
        'title': 'Update antivirus endpoint tertunda',
        'description':
            'Beberapa endpoint belum menerima update definisi antivirus sejak 3 hari.',
        'category': 'Software',
        'priority': TicketPriority.high,
        'status': TicketStatus.open,
        'reporterId': 'u1',
        'assigneeId': 'a1',
        'daysAgo': 11,
      },
      {
        'title': 'Scanner dokumen tidak terdeteksi',
        'description':
            'Scanner dokumen di front office tidak terdeteksi pada aplikasi arsip.',
        'category': 'Hardware',
        'priority': TicketPriority.medium,
        'status': TicketStatus.closed,
        'reporterId': 'u1',
        'assigneeId': 'h1',
        'daysAgo': 12,
      },
    ];

    for (var i = 0; i < seeds.length; i++) {
      final seed = seeds[i];
      final id = 't${i + 1}';
      final ticketNumber = 'TK-${(i + 1).toString().padLeft(3, '0')}';
      final daysAgo = seed['daysAgo'] as int;
      final createdAt = now.subtract(Duration(days: daysAgo));
      final updatedAt = createdAt.add(const Duration(hours: 6));
      final status = seed['status'] as TicketStatus;

      final ticket = TicketModel(
        id: id,
        ticketNumber: ticketNumber,
        title: seed['title'] as String,
        description: seed['description'] as String,
        category: seed['category'] as String,
        priority: seed['priority'] as TicketPriority,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
        reporterId: seed['reporterId'] as String,
        assigneeId: seed['assigneeId'] as String?,
        attachments: const [],
        history: [
          StatusHistory(
            status: TicketStatus.open,
            changedBy: 'System',
            changedAt: createdAt,
            note: 'Tiket dibuat',
          ),
          if (status != TicketStatus.open)
            StatusHistory(
              status: status,
              changedBy: 'Nadia Helpdesk',
              changedAt: updatedAt,
              note: 'Status diperbarui',
            ),
        ],
      );

      _tickets.add(ticket);
      _commentsByTicket[id] = [
        CommentModel(
          id: 'c${i + 1}',
          ticketId: id,
          userId: ticket.reporterId,
          userName: 'Ari Pratama',
          content: 'Mohon dibantu follow up untuk tiket ini.',
          createdAt: createdAt.add(const Duration(hours: 1)),
        ),
      ];
    }
  }

  @override
  Future<List<TicketModel>> getTickets({
    TicketStatus? status,
    String query = '',
    int page = 1,
    int limit = 10,
    String? reporterId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    Iterable<TicketModel> result = _tickets;

    if (reporterId != null && reporterId.isNotEmpty) {
      result = result.where((item) => item.reporterId == reporterId);
    }

    if (status != null) {
      result = result.where((item) => item.status == status);
    }

    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isNotEmpty) {
      result = result.where(
        (item) =>
            item.ticketNumber.toLowerCase().contains(normalizedQuery) ||
            item.title.toLowerCase().contains(normalizedQuery) ||
            item.category.toLowerCase().contains(normalizedQuery),
      );
    }

    final sorted = result.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final start = (page - 1) * limit;
    if (start >= sorted.length) {
      return [];
    }

    final end = min(start + limit, sorted.length);
    return sorted.sublist(start, end);
  }

  @override
  Future<TicketModel?> getTicketById(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    for (final ticket in _tickets) {
      if (ticket.id == ticketId) {
        return ticket;
      }
    }
    return null;
  }

  @override
  Future<TicketModel> createTicket({
    required String title,
    required String description,
    required String category,
    required TicketPriority priority,
    required String reporterId,
    List<String> attachments = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    _ticketCounter += 1;
    final now = DateTime.now();
    final ticket = TicketModel(
      id: 't$_ticketCounter',
      ticketNumber: 'TK-${_ticketCounter.toString().padLeft(3, '0')}',
      title: title,
      description: description,
      category: category,
      priority: priority,
      status: TicketStatus.open,
      createdAt: now,
      updatedAt: now,
      reporterId: reporterId,
      assigneeId: null,
      attachments: attachments,
      history: [
        StatusHistory(
          status: TicketStatus.open,
          changedBy: 'Pelapor',
          changedAt: now,
          note: 'Tiket dibuat',
        ),
      ],
    );

    _tickets.add(ticket);
    _commentsByTicket[ticket.id] = [];
    return ticket;
  }

  @override
  Future<TicketModel?> updateStatus({
    required String ticketId,
    required TicketStatus status,
    required String updatedBy,
    String? note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _tickets.indexWhere((item) => item.id == ticketId);
    if (index < 0) {
      return null;
    }

    final old = _tickets[index];
    final now = DateTime.now();
    final updated = old.copyWith(
      status: status,
      updatedAt: now,
      history: [
        ...old.history,
        StatusHistory(
          status: status,
          changedBy: updatedBy,
          changedAt: now,
          note: note,
        ),
      ],
    );

    _tickets[index] = updated;
    return updated;
  }

  @override
  Future<TicketModel?> assignTicket({
    required String ticketId,
    required String assigneeId,
    required String updatedBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _tickets.indexWhere((item) => item.id == ticketId);
    if (index < 0) {
      return null;
    }

    final old = _tickets[index];
    final now = DateTime.now();
    final updated = old.copyWith(
      assigneeId: assigneeId,
      updatedAt: now,
      history: [
        ...old.history,
        StatusHistory(
          status: old.status,
          changedBy: updatedBy,
          changedAt: now,
          note: 'Tiket di-assign ke $assigneeId',
        ),
      ],
    );

    _tickets[index] = updated;
    return updated;
  }

  @override
  Future<CommentModel> addComment({
    required String ticketId,
    required String userId,
    required String userName,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 450));

    final comment = CommentModel(
      id: 'cm-${DateTime.now().millisecondsSinceEpoch}',
      ticketId: ticketId,
      userId: userId,
      userName: userName,
      content: content,
      createdAt: DateTime.now(),
    );

    final comments = _commentsByTicket.putIfAbsent(ticketId, () => []);
    comments.add(comment);
    return comment;
  }

  @override
  Future<List<CommentModel>> getComments(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final comments = _commentsByTicket[ticketId] ?? [];
    final sorted = [...comments]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return sorted;
  }

  @override
  Future<String> uploadAttachment(Uint8List bytes, String fileName) async {
    return 'https://dummy.storage.example/$fileName';
  }
}
