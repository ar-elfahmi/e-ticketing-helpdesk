import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/comment_model.dart';
import '../../data/models/ticket_model.dart';
import '../../data/repositories/ticket_repository.dart';

class TicketProvider extends ChangeNotifier {
  TicketProvider({required TicketRepository ticketRepository})
    : _ticketRepository = ticketRepository;

  final TicketRepository _ticketRepository;

  final List<TicketModel> _tickets = [];
  TicketModel? _selectedTicket;
  List<CommentModel> _comments = [];

  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;

  TicketStatus? _filterStatus;
  String _searchQuery = '';
  String? _lastReporterId;
  Timer? _debounce;

  List<TicketModel> get tickets => _tickets;
  TicketModel? get selectedTicket => _selectedTicket;
  List<CommentModel> get comments => _comments;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  TicketStatus? get filterStatus => _filterStatus;
  String get searchQuery => _searchQuery;

  Future<void> fetchTickets({
    bool refresh = false,
    String? reporterId,
    int limit = 10,
  }) async {
    if (_isLoading) {
      return;
    }

    if (refresh) {
      _page = 1;
      _hasMore = true;
      _tickets.clear();
    }

    if (!_hasMore) {
      return;
    }

    _isLoading = true;
    _lastReporterId = reporterId;
    notifyListeners();

    final items = await _ticketRepository.getTickets(
      status: _filterStatus,
      query: _searchQuery,
      page: _page,
      limit: limit,
      reporterId: reporterId,
    );

    if (items.length < limit) {
      _hasMore = false;
    }

    _tickets.addAll(items);
    _page += 1;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDetail(String ticketId) async {
    _isLoading = true;
    notifyListeners();

    _selectedTicket = await _ticketRepository.getTicketById(ticketId);
    _comments = await _ticketRepository.getComments(ticketId);

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createTicket({
    required String title,
    required String description,
    required String category,
    required TicketPriority priority,
    required String reporterId,
    List<String> attachments = const [],
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final created = await _ticketRepository.createTicket(
        title: title,
        description: description,
        category: category,
        priority: priority,
        reporterId: reporterId,
        attachments: attachments,
      );

      _tickets.insert(0, created);
      _hasMore = true;
      return true;
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStatus({
    required String ticketId,
    required TicketStatus status,
    required String updatedBy,
  }) async {
    final updated = await _ticketRepository.updateStatus(
      ticketId: ticketId,
      status: status,
      updatedBy: updatedBy,
    );

    if (updated == null) {
      return false;
    }

    _replaceTicket(updated);
    if (_selectedTicket?.id == ticketId) {
      _selectedTicket = updated;
    }

    notifyListeners();
    return true;
  }

  Future<bool> assignTicket({
    required String ticketId,
    required String assigneeId,
    required String updatedBy,
  }) async {
    final updated = await _ticketRepository.assignTicket(
      ticketId: ticketId,
      assigneeId: assigneeId,
      updatedBy: updatedBy,
    );

    if (updated == null) {
      return false;
    }

    _replaceTicket(updated);
    if (_selectedTicket?.id == ticketId) {
      _selectedTicket = updated;
    }

    notifyListeners();
    return true;
  }

  Future<bool> addComment({
    required String ticketId,
    required String userId,
    required String userName,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      return false;
    }

    final comment = await _ticketRepository.addComment(
      ticketId: ticketId,
      userId: userId,
      userName: userName,
      content: content,
    );

    _comments = [..._comments, comment];
    notifyListeners();
    return true;
  }

  void setFilterStatus(TicketStatus? status) {
    _filterStatus = status;
    fetchTickets(refresh: true, reporterId: _lastReporterId);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      fetchTickets(refresh: true, reporterId: _lastReporterId);
    });
  }

  Future<void> refresh() async {
    await fetchTickets(refresh: true, reporterId: _lastReporterId);
  }

  void _replaceTicket(TicketModel ticket) {
    final index = _tickets.indexWhere((item) => item.id == ticket.id);
    if (index < 0) {
      return;
    }
    _tickets[index] = ticket;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
