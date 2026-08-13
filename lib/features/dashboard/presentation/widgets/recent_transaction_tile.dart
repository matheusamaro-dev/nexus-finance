import 'package:flutter/material.dart';

import '../../../../core/design_system/nexus_colors.dart';
import '../../../transactions/domain/entities/financial_transaction.dart';
import '../../../transactions/domain/entities/transaction_type.dart';

class RecentTransactionTile extends StatelessWidget {
  const RecentTransactionTile({super.key, required this.transaction});

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

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}
