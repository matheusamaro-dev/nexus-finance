import 'package:flutter/material.dart';

import '../../../../core/design_system/components/nexus_section_title.dart';
import '../../../../core/design_system/nexus_spacing.dart';
import '../models/dashboard_summary.dart';
import 'balance_card.dart';
import 'quick_action.dart';
import 'recent_transactions_section.dart';
import 'summary_card.dart';

class DashboardFinancialContent extends StatelessWidget {
  const DashboardFinancialContent({
    super.key,
    required this.summary,
    required this.onAddIncome,
    required this.onAddExpense,
  });

  final DashboardSummary summary;
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BalanceCard(
          balance: summary.balance,
          transactionCount: summary.transactionCount,
        ),
        const SizedBox(height: NexusSpacing.md),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Receitas',
                value: summary.income.format(),
                icon: Icons.arrow_downward_rounded,
                positive: true,
              ),
            ),
            const SizedBox(width: NexusSpacing.md),
            Expanded(
              child: SummaryCard(
                title: 'Despesas',
                value: summary.expenses.format(),
                icon: Icons.arrow_upward_rounded,
                positive: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: NexusSpacing.xl),
        const NexusSectionTitle(title: 'Ações rápidas'),
        const SizedBox(height: NexusSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuickAction(
              label: 'Receita',
              icon: Icons.add_rounded,
              onPressed: onAddIncome,
            ),
            QuickAction(
              label: 'Despesa',
              icon: Icons.remove_rounded,
              onPressed: onAddExpense,
            ),
            const QuickAction(
              label: 'Conta',
              icon: Icons.calendar_month_rounded,
            ),
            const QuickAction(label: 'Cartão', icon: Icons.credit_card_rounded),
          ],
        ),
        const SizedBox(height: NexusSpacing.xl),
        RecentTransactionsSection(transactions: summary.recentTransactions),
      ],
    );
  }
}
