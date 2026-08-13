import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/components/nexus_card.dart';
import '../../../../core/design_system/nexus_spacing.dart';
import '../../../../core/money/money.dart';
import '../../../transactions/domain/entities/financial_transaction.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../domain/entities/monthly_spending_plan.dart';
import '../models/monthly_plan_summary.dart';
import 'monthly_plan_card.dart';

class PlanningContent extends StatelessWidget {
  const PlanningContent({
    super.key,
    required this.planAsync,
    required this.transactionsAsync,
    required this.referenceDate,
    required this.onCreatePlan,
    required this.onEditPlan,
    required this.onRemovePlan,
    required this.onRetry,
  });

  final AsyncValue<MonthlySpendingPlan?> planAsync;
  final AsyncValue<List<FinancialTransaction>> transactionsAsync;
  final DateTime referenceDate;
  final VoidCallback onCreatePlan;
  final ValueChanged<MonthlySpendingPlan> onEditPlan;
  final ValueChanged<MonthlySpendingPlan> onRemovePlan;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (planAsync.isLoading || transactionsAsync.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (planAsync.hasError || transactionsAsync.hasError) {
      return _PlanningErrorState(onRetry: onRetry);
    }

    final plan = planAsync.value;
    final transactions = transactionsAsync.value ?? const [];
    final expenses = _monthlyExpenses(transactions, referenceDate);

    if (plan == null) {
      return EmptyPlanCard(expenses: expenses, onCreate: onCreatePlan);
    }

    return MonthlyPlanCard(
      plan: plan,
      summary: MonthlyPlanSummary(limit: plan.limit, expenses: expenses),
      onEdit: () => onEditPlan(plan),
      onRemove: () => onRemovePlan(plan),
    );
  }

  static Money _monthlyExpenses(
    List<FinancialTransaction> transactions,
    DateTime referenceDate,
  ) {
    var expenses = const Money.zero();

    for (final transaction in transactions) {
      final isSelectedMonth =
          transaction.date.year == referenceDate.year &&
          transaction.date.month == referenceDate.month;

      if (isSelectedMonth && transaction.type == TransactionType.expense) {
        expenses += transaction.amount;
      }
    }

    return expenses;
  }
}

class _PlanningErrorState extends StatelessWidget {
  const _PlanningErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return NexusCard(
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, size: 42, color: colors.error),
          const SizedBox(height: NexusSpacing.md),
          const Text('Não foi possível carregar o planejamento.'),
          const SizedBox(height: NexusSpacing.md),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
