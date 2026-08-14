import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/nexus_spacing.dart';
import '../../recurring_bills/presentation/pages/recurring_bills_page.dart';
import '../../transactions/application/providers/transactions_providers.dart';
import '../../transactions/domain/entities/transaction_type.dart';
import '../../transactions/presentation/pages/new_transaction_page.dart';
import 'models/dashboard_summary.dart';
import 'widgets/dashboard_error_state.dart';
import 'widgets/dashboard_financial_content.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_loading_state.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key, this.initialReferenceDate, this.currentDate});

  final DateTime? initialReferenceDate;
  final DateTime? currentDate;

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late DateTime _referenceDate;

  @override
  void initState() {
    super.initState();
    final initialDate = widget.initialReferenceDate ?? DateTime.now();
    _referenceDate = DateTime(initialDate.year, initialDate.month);
  }

  bool get _isCurrentMonth {
    final now = widget.currentDate ?? DateTime.now();
    return _referenceDate.year == now.year && _referenceDate.month == now.month;
  }

  void _showPreviousMonth() {
    setState(() {
      _referenceDate = DateTime(_referenceDate.year, _referenceDate.month - 1);
    });
  }

  void _showNextMonth() {
    if (_isCurrentMonth) {
      return;
    }

    setState(() {
      _referenceDate = DateTime(_referenceDate.year, _referenceDate.month + 1);
    });
  }

  Future<void> _openTransactionForm(
    BuildContext context,
    TransactionType type,
  ) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => NewTransactionPage(initialType: type)),
    );
  }

  Future<void> _openRecurringBills(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => RecurringBillsPage(referenceDate: _referenceDate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              NexusSpacing.lg,
              NexusSpacing.md,
              NexusSpacing.lg,
              NexusSpacing.xl,
            ),
            sliver: SliverList.list(
              children: [
                const DashboardHeader(),
                const SizedBox(height: NexusSpacing.xl),
                Text(
                  'Visão geral',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: NexusSpacing.xs),
                Row(
                  children: [
                    IconButton.outlined(
                      tooltip: 'Mês anterior',
                      onPressed: _showPreviousMonth,
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Expanded(
                      child: Text(
                        _formatMonthYear(_referenceDate),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton.outlined(
                      tooltip: 'Próximo mês',
                      onPressed: _isCurrentMonth ? null : _showNextMonth,
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
                if (!_isCurrentMonth) ...[
                  const SizedBox(height: NexusSpacing.xs),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        final now = widget.currentDate ?? DateTime.now();
                        setState(() {
                          _referenceDate = DateTime(now.year, now.month);
                        });
                      },
                      child: const Text('Voltar para o mês atual'),
                    ),
                  ),
                ],
                const SizedBox(height: NexusSpacing.md),
                transactionsAsync.when(
                  data: (transactions) {
                    final summary = DashboardSummary.fromTransactions(
                      transactions,
                      referenceDate: _referenceDate,
                    );

                    return DashboardFinancialContent(
                      summary: summary,
                      onAddIncome: () =>
                          _openTransactionForm(context, TransactionType.income),
                      onAddExpense: () => _openTransactionForm(
                        context,
                        TransactionType.expense,
                      ),
                      onOpenBills: () => _openRecurringBills(context),
                    );
                  },
                  loading: DashboardLoadingState.new,
                  error: (error, stackTrace) => DashboardErrorState(
                    onRetry: () {
                      ref.invalidate(transactionsStreamProvider);
                    },
                  ),
                ),
                const SizedBox(height: NexusSpacing.xl),
                Center(
                  child: Text(
                    'Nexus Finance • Financial Core v0.3.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatMonthYear(DateTime date) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return '${months[date.month - 1]} de ${date.year}';
  }
}
