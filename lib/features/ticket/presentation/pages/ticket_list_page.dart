import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/ticket_model.dart';
import '../providers/ticket_provider.dart';
import '../widgets/ticket_card_widget.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({super.key});

  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitial();
    });
  }

  Future<void> _loadInitial() async {
    final reporterId = _getReporterId();
    await context.read<TicketProvider>().fetchTickets(
      refresh: true,
      reporterId: reporterId,
    );
  }

  String? _getReporterId() {
    final user = context.read<AuthProvider>().currentUser;
    if (user?.role == UserRole.user) {
      return user?.id;
    }
    return null;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<TicketProvider>();
      if (!provider.isLoading && provider.hasMore) {
        provider.fetchTickets(reporterId: _getReporterId());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthProvider>().currentUser;
    final ticketProvider = context.watch<TicketProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tiket')),
      floatingActionButton: authUser?.role == UserRole.user
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context)
                    .pushNamed(AppRoutes.createTicket);
                if (mounted) {
                  ticketProvider.fetchTickets(
                    refresh: true,
                    reporterId: _getReporterId(),
                  );
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari nomor, judul, kategori tiket...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: ticketProvider.setSearchQuery,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildFilterChip(context, null, 'Semua'),
                _buildFilterChip(context, TicketStatus.open, 'Open'),
                _buildFilterChip(context, TicketStatus.assign, 'Assign'),
                _buildFilterChip(
                  context,
                  TicketStatus.inProgress,
                  'In Progress',
                ),
                _buildFilterChip(context, TicketStatus.closed, 'Closed'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ticketProvider.fetchTickets(
                refresh: true,
                reporterId: _getReporterId(),
              ),
              child: Builder(
                builder: (context) {
                  if (ticketProvider.isLoading &&
                      ticketProvider.tickets.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: LoadingWidget(itemCount: 6),
                    );
                  }

                  if (ticketProvider.tickets.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'Tidak ada tiket ditemukan',
                      message:
                          'Coba ganti kata kunci pencarian atau filter status.',
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    itemCount:
                        ticketProvider.tickets.length +
                        (ticketProvider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= ticketProvider.tickets.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final ticket = ticketProvider.tickets[index];
                      return TicketCardWidget(
                        ticket: ticket,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.ticketDetail,
                            arguments: ticket.id,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    TicketStatus? status,
    String label,
  ) {
    final provider = context.watch<TicketProvider>();
    final isSelected = provider.filterStatus == status;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) {
          context.read<TicketProvider>().setFilterStatus(status);
        },
      ),
    );
  }
}
