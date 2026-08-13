import 'package:flutter/material.dart';

import '../../../../core/design_system/components/nexus_card.dart';
import '../../../../core/design_system/nexus_spacing.dart';
import '../../../../core/money/money.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.transactionCount,
  });

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
