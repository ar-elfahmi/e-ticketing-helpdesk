import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/status_badge.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/ticket_model.dart';
import '../providers/ticket_provider.dart';
import '../widgets/comment_bubble_widget.dart';
import '../widgets/ticket_status_timeline.dart';

class TicketDetailPage extends StatefulWidget {
  const TicketDetailPage({required this.ticketId, super.key});

  final String ticketId;

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().fetchDetail(widget.ticketId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) {
      return;
    }

    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      return;
    }

    await context.read<TicketProvider>().addComment(
      ticketId: widget.ticketId,
      userId: user.id,
      userName: user.name,
      content: text,
    );

    _commentController.clear();
  }

  Future<void> _updateStatus(TicketStatus? status) async {
    if (status == null) {
      return;
    }

    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      return;
    }

    await context.read<TicketProvider>().updateStatus(
      ticketId: widget.ticketId,
      status: status,
      updatedBy: user.name,
    );
  }

  Future<void> _assignTicket() async {
    final selectedAssignee = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Assign ke Nadia Helpdesk'),
                onTap: () => Navigator.of(context).pop('h1'),
              ),
              ListTile(
                title: const Text('Assign ke Raka Admin'),
                onTap: () => Navigator.of(context).pop('a1'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (selectedAssignee == null) {
      return;
    }

    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      return;
    }

    await context.read<TicketProvider>().assignTicket(
      ticketId: widget.ticketId,
      assigneeId: selectedAssignee,
      updatedBy: user.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final ticketProvider = context.watch<TicketProvider>();
    final ticket = ticketProvider.selectedTicket;

    if (ticketProvider.isLoading && ticket == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (ticket == null) {
      return const Scaffold(
        body: Center(child: Text('Tiket tidak ditemukan.')),
      );
    }

    final isStaff =
        user?.role == UserRole.helpdesk || user?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(title: Text(ticket.ticketNumber)),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  context.read<TicketProvider>().fetchDetail(ticket.id),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticket.title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          StatusBadge(status: ticket.status.label),
                          const SizedBox(height: 10),
                          Text('Kategori: ${ticket.category}'),
                          Text('Prioritas: ${ticket.priority.label}'),
                          const SizedBox(height: 10),
                          Text(ticket.description),
                          if (ticket.attachments.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            const Text('Lampiran:'),
                            const SizedBox(height: 4),
                            ...ticket.attachments.map(
                              (item) => Row(
                                children: [
                                  const Icon(Icons.attach_file, size: 16),
                                  Expanded(
                                    child: Text(
                                      item,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isStaff)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Aksi Helpdesk/Admin'),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<TicketStatus>(
                              key: ValueKey(ticket.status),
                              initialValue: ticket.status,
                              decoration: const InputDecoration(
                                labelText: 'Ubah Status',
                              ),
                              items: TicketStatus.values
                                  .map(
                                    (status) => DropdownMenuItem<TicketStatus>(
                                      value: status,
                                      child: Text(status.label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: _updateStatus,
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: _assignTicket,
                              icon: const Icon(Icons.assignment_ind_outlined),
                              label: const Text('Assign ke...'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    'Timeline Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TicketStatusTimeline(history: ticket.history),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Komentar',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (ticketProvider.comments.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Belum ada komentar.'),
                      ),
                    )
                  else
                    ...ticketProvider.comments.map(
                      (comment) => CommentBubbleWidget(
                        comment: comment,
                        isMine: comment.userId == user?.id,
                      ),
                    ),
                  const SizedBox(height: 84),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Tulis komentar...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendComment,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
