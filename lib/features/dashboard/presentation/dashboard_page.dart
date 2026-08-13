import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/nexus_spacing.dart';
import '../../transactions/application/providers/transactions_providers.dart';
import '../../transactions/domain/entities/transaction_type.dart';
import '../../transactions/presentation/pages/new_transaction_page.dart';
import 'models/dashboard_summary.dart';
import 'widgets/dashboard_error_state.dart';
import 'widgets/dashboard_financial_content.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_loading_state.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  Future<void> _openTransactionForm(
    BuildContext context,
    TransactionType type,
  ) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => NewTransactionPage(initialType: type)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Text(
                  _formatMonthYear(DateTime.now()),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: NexusSpacing.md),
                transactionsAsync.when(
                  data: (transactions) {
                    final summary = DashboardSummary.fromTransactions(
                      transactions,
                      referenceDate: DateTime.now(),
                    );

                    return DashboardFinancialContent(
                      summary: summary,
                      onAddIncome: () =>
                          _openTransactionForm(context, TransactionType.income),
                      onAddExpense: () => _openTransactionForm(
                        context,
                        TransactionType.expense,
                      ),
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
