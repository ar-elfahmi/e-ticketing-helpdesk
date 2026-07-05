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

  Future<void> _adminAccept() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    await context.read<TicketProvider>().updateStatus(
      ticketId: widget.ticketId,
      status: TicketStatus.assign,
      updatedBy: user.name,
      note: 'Tiket diterima oleh admin',
    );
  }

  Future<void> _adminUpdateStatus(TicketStatus? status) async {
    if (status == null) return;

    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    await context.read<TicketProvider>().updateStatus(
      ticketId: widget.ticketId,
      status: status,
      updatedBy: user.name,
    );
  }

  Future<void> _helpdeskAccept() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    await context.read<TicketProvider>().assignTicket(
      ticketId: widget.ticketId,
      assigneeId: user.id,
      updatedBy: user.name,
    );

    await context.read<TicketProvider>().updateStatus(
      ticketId: widget.ticketId,
      status: TicketStatus.inProgress,
      updatedBy: user.name,
      note: 'Dikerjakan oleh helpdesk',
    );
  }

  Future<void> _helpdeskFinish() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    await context.read<TicketProvider>().updateStatus(
      ticketId: widget.ticketId,
      status: TicketStatus.closed,
      updatedBy: user.name,
      note: 'Tiket selesai dikerjakan',
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
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ticket.attachments.map((url) {
                                final fileName = url.split('/').last.toLowerCase();
                                final isImage = fileName.endsWith('.jpg') ||
                                    fileName.endsWith('.jpeg') ||
                                    fileName.endsWith('.png') ||
                                    fileName.endsWith('.gif') ||
                                    fileName.endsWith('.webp');
                                if (isImage) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (_) => Scaffold(
                                            appBar: AppBar(),
                                            body: Center(
                                              child: InteractiveViewer(
                                                child: Image.network(
                                                  url,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Center(
                                                    child: Icon(
                                                      Icons.broken_image_outlined,
                                                      size: 48,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        url,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.broken_image_outlined,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Row(
                                  children: [
                                    const Icon(Icons.attach_file, size: 16),
                                    Expanded(
                                      child: Text(
                                        fileName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
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
                              const Text('Aksi'),
                              const SizedBox(height: 10),
                              if (user?.role == UserRole.admin)
                                DropdownButtonFormField<TicketStatus>(
                                  decoration: const InputDecoration(
                                    labelText: 'Ubah Status (Admin)',
                                  ),
                                  items: TicketStatus.values
                                      .map(
                                        (status) => DropdownMenuItem<TicketStatus>(
                                          value: status,
                                          child: Text(status.label),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: _adminUpdateStatus,
                                ),
                              if (user?.role == UserRole.admin && ticket.status == TicketStatus.open)
                                const SizedBox(height: 10),
                              if (user?.role == UserRole.admin && ticket.status == TicketStatus.open)
                                OutlinedButton.icon(
                                  onPressed: _adminAccept,
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text('Terima Tiket'),
                                ),
                              if (user?.role == UserRole.helpdesk && ticket.status == TicketStatus.assign)
                                const SizedBox(height: 10),
                              if (user?.role == UserRole.helpdesk && ticket.status == TicketStatus.assign)
                                OutlinedButton.icon(
                                  onPressed: _helpdeskAccept,
                                  icon: const Icon(Icons.assignment_turned_in_outlined),
                                  label: const Text('Terima & Kerjakan'),
                                ),
                              if (user?.role == UserRole.helpdesk && ticket.status == TicketStatus.inProgress)
                                const SizedBox(height: 10),
                              if (user?.role == UserRole.helpdesk && ticket.status == TicketStatus.inProgress)
                                OutlinedButton.icon(
                                  onPressed: _helpdeskFinish,
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text('Selesaikan Tiket'),
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
