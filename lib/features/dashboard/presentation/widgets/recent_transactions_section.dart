import 'package:flutter/material.dart';

import '../../../../core/design_system/components/nexus_card.dart';
import '../../../../core/design_system/components/nexus_empty_state.dart';
import '../../../../core/design_system/components/nexus_section_title.dart';
import '../../../../core/design_system/nexus_spacing.dart';
import '../../../transactions/domain/entities/financial_transaction.dart';
import 'recent_transaction_tile.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key, required this.transactions});

  final List<FinancialTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NexusSectionTitle(title: 'Lançamentos do mês'),
        const SizedBox(height: NexusSpacing.md),
        if (transactions.isEmpty)
          const NexusEmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'A lista deste mês está vazia',
            message: 'Selecione outro mês ou adicione uma receita ou despesa.',
          )
        else
          NexusCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < transactions.length; index++) ...[
                  RecentTransactionTile(transaction: transactions[index]),
                  if (index < transactions.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
