import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../ticket/data/models/ticket_model.dart';
import '../providers/ticket_provider.dart';

class AdminManageTicketsPage extends StatefulWidget {
  const AdminManageTicketsPage({super.key});

  @override
  State<AdminManageTicketsPage> createState() => _AdminManageTicketsPageState();
}

class _AdminManageTicketsPageState extends State<AdminManageTicketsPage> {
  final TextEditingController _searchController = TextEditingController();
  TicketStatus? _filterStatus;
  List<TicketModel> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTickets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    setState(() {
      _isLoading = true;
    });

    final tickets = await context.read<TicketProvider>().fetchTicketsForAdmin(
      status: _filterStatus,
      query: _searchController.text.trim(),
      page: 1,
      limit: 50,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _tickets = tickets;
      _isLoading = false;
    });
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Tiket')),
      body: RefreshIndicator(
        onRefresh: _loadTickets,
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
                      'Dashboard Tiket Admin',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cari tiket, filter status, lalu buka detail tiket untuk proses lanjut.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Cari tiket',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _loadTickets();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                      onSubmitted: (_) => _loadTickets(),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Semua'),
                          selected: _filterStatus == null,
                          onSelected: (selected) {
                            setState(() {
                              _filterStatus = null;
                            });
                            _loadTickets();
                          },
                        ),
                        ...TicketStatus.values.map(
                          (status) => FilterChip(
                            label: Text(status.label),
                            selected: _filterStatus == status,
                            onSelected: (selected) {
                              setState(() {
                                _filterStatus = selected ? status : null;
                              });
                              _loadTickets();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_tickets.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('Tidak ada tiket yang cocok.')),
                ),
              )
            else
              ..._tickets.map(
                (ticket) => Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.ticketDetail,
                        arguments: ticket.id,
                      );
                    },
                    leading: const CircleAvatar(
                      child: Icon(Icons.confirmation_number_outlined),
                    ),
                    title: Text(ticket.title),
                    subtitle: Text(
                      '${ticket.ticketNumber} • ${ticket.category}\nDibuat ${_formatDate(ticket.createdAt)}',
                    ),
                    isThreeLine: true,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatusBadge(status: ticket.status.label),
                        const SizedBox(height: 6),
                        Text(
                          ticket.priority.label,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Akses',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text('Masuk sebagai: ${authUser?.name ?? '-'}'),
                    Text('Role: ${authUser?.role.displayName ?? '-'}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
