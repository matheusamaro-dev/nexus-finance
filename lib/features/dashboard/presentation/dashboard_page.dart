import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/components/nexus_card.dart';
import '../../../core/design_system/components/nexus_empty_state.dart';
import '../../../core/design_system/components/nexus_section_title.dart';
import '../../../core/design_system/components/nexus_status_chip.dart';
import '../../../core/design_system/nexus_colors.dart';
import '../../../core/design_system/nexus_spacing.dart';
import '../../../core/money/money.dart';
import '../../transactions/application/providers/transactions_providers.dart';
import '../../transactions/domain/entities/financial_transaction.dart';
import '../../transactions/domain/entities/transaction_type.dart';
import '../../transactions/presentation/pages/new_transaction_page.dart';

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
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
            sliver: SliverList.list(
              children: [
                _DashboardHeader(colors: colors),
                const SizedBox(height: 28),
                Text(
                  'Visão geral',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatMonthYear(DateTime.now()),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                transactionsAsync.when(
                  data: (transactions) {
                    final summary = _DashboardSummary.fromTransactions(
                      transactions,
                      referenceDate: DateTime.now(),
                    );

                    return _DashboardFinancialContent(
                      summary: summary,
                      onAddIncome: () =>
                          _openTransactionForm(context, TransactionType.income),
                      onAddExpense: () => _openTransactionForm(
                        context,
                        TransactionType.expense,
                      ),
                    );
                  },
                  loading: () => const _DashboardLoadingState(),
                  error: (error, stackTrace) => _DashboardErrorState(
                    onRetry: () {
                      ref.invalidate(transactionsStreamProvider);
                    },
                  ),
                ),
                const SizedBox(height: 24),
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
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: colors.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEXUS FINANCE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Olá, Matheus',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notificações',
          onPressed: null,
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}

class _DashboardFinancialContent extends StatelessWidget {
  const _DashboardFinancialContent({
    required this.summary,
    required this.onAddIncome,
    required this.onAddExpense,
  });

  final _DashboardSummary summary;
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BalanceCard(
          balance: summary.balance,
          transactionCount: summary.transactionCount,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Receitas',
                value: summary.income.format(),
                icon: Icons.arrow_downward_rounded,
                positive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: 'Despesas',
                value: summary.expenses.format(),
                icon: Icons.arrow_upward_rounded,
                positive: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const NexusSectionTitle(title: 'Ações rápidas'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _QuickAction(
              label: 'Receita',
              icon: Icons.add_rounded,
              onPressed: onAddIncome,
            ),
            _QuickAction(
              label: 'Despesa',
              icon: Icons.remove_rounded,
              onPressed: onAddExpense,
            ),
            const _QuickAction(
              label: 'Conta',
              icon: Icons.calendar_month_rounded,
            ),
            const _QuickAction(
              label: 'Cartão',
              icon: Icons.credit_card_rounded,
            ),
          ],
        ),
        const SizedBox(height: 28),
        _RecentTransactionsSection(transactions: summary.recentTransactions),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance, required this.transactionCount});

  final Money balance;
  final int transactionCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isNegative = balance.isNegative;

    return NexusCard(
      color: colors.primaryContainer,
      padding: const EdgeInsets.all(NexusSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo do mês',
            style: TextStyle(
              color: colors.onPrimaryContainer.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: NexusSpacing.sm),
          Text(
            balance.format(),
            style: TextStyle(
              color: isNegative ? colors.error : colors.onPrimaryContainer,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: NexusSpacing.lg),
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 18,
                color: colors.onPrimaryContainer,
              ),
              const SizedBox(width: NexusSpacing.sm),
              Expanded(
                child: Text(
                  _transactionCountLabel(transactionCount),
                  style: TextStyle(
                    color: colors.onPrimaryContainer,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _transactionCountLabel(int count) {
    if (count == 0) {
      return 'Nenhum lançamento neste mês';
    }

    if (count == 1) {
      return '1 lançamento neste mês';
    }

    return '$count lançamentos neste mês';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.positive,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final accent = positive ? NexusColors.income : NexusColors.expense;

    return NexusCard(
      padding: const EdgeInsets.all(NexusSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NexusStatusChip(
            label: title,
            icon: icon,
            type: positive
                ? NexusStatusChipType.success
                : NexusStatusChipType.error,
          ),
          const SizedBox(height: NexusSpacing.lg),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon, this.onPressed});

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 24,
          padding: const EdgeInsets.all(16),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: TextStyle(
            color: onPressed == null
                ? colors.onSurfaceVariant.withValues(alpha: 0.45)
                : colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RecentTransactionsSection extends StatelessWidget {
  const _RecentTransactionsSection({required this.transactions});

  final List<FinancialTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NexusSectionTitle(title: 'Últimos lançamentos'),
        const SizedBox(height: NexusSpacing.md),
        if (transactions.isEmpty)
          const NexusEmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Nenhum lançamento cadastrado',
            message: 'Suas receitas e despesas aparecerão aqui.',
          )
        else
          NexusCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < transactions.length; index++) ...[
                  _RecentTransactionTile(transaction: transactions[index]),
                  if (index < transactions.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _RecentTransactionTile extends StatelessWidget {
  const _RecentTransactionTile({required this.transaction});

  final FinancialTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isIncome = transaction.type == TransactionType.income;

    return ListTile(
      leading: CircleAvatar(
        child: Icon(
          isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
        ),
      ),
      title: Text(
        transaction.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        transaction.category?.trim().isNotEmpty == true
            ? transaction.category!
            : _formatDate(transaction.date),
      ),
      trailing: Text(
        '${isIncome ? '+' : '-'} ${transaction.amount.format()}',
        style: TextStyle(
          color: isIncome ? NexusColors.income : colors.error,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DashboardLoadingState extends StatelessWidget {
  const _DashboardLoadingState();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 320,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _DashboardErrorState extends StatelessWidget {
  const _DashboardErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return NexusEmptyState(
      icon: Icons.error_outline_rounded,
      title: 'Não foi possível carregar o resumo financeiro',
      message: 'Verifique os dados e tente carregar novamente.',
      action: OutlinedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Tentar novamente'),
      ),
    );
  }
}

final class _DashboardSummary {
  const _DashboardSummary({
    required this.income,
    required this.expenses,
    required this.balance,
    required this.transactionCount,
    required this.recentTransactions,
  });

  factory _DashboardSummary.fromTransactions(
    List<FinancialTransaction> transactions, {
    required DateTime referenceDate,
  }) {
    final monthlyTransactions = transactions.where((transaction) {
      return transaction.date.year == referenceDate.year &&
          transaction.date.month == referenceDate.month;
    }).toList();

    var income = const Money.zero();
    var expenses = const Money.zero();

    for (final transaction in monthlyTransactions) {
      switch (transaction.type) {
        case TransactionType.income:
          income += transaction.amount;
        case TransactionType.expense:
          expenses += transaction.amount;
      }
    }

    final recentTransactions = transactions.take(3).toList();

    return _DashboardSummary(
      income: income,
      expenses: expenses,
      balance: income - expenses,
      transactionCount: monthlyTransactions.length,
      recentTransactions: recentTransactions,
    );
  }

  final Money income;
  final Money expenses;
  final Money balance;
  final int transactionCount;
  final List<FinancialTransaction> recentTransactions;
}

String _formatMonthYear(DateTime date) {
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

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '$day/$month/${date.year}';
}
