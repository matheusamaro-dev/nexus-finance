import 'package:flutter/material.dart';

import '../../../../core/design_system/components/nexus_card.dart';
import '../../../../core/design_system/nexus_spacing.dart';
import '../../../../core/money/money.dart';
import '../../domain/entities/monthly_spending_plan.dart';
import '../models/monthly_plan_summary.dart';

class EmptyPlanCard extends StatelessWidget {
  const EmptyPlanCard({
    super.key,
    required this.expenses,
    required this.onCreate,
  });

  final Money expenses;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return NexusCard(
      padding: const EdgeInsets.all(NexusSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.track_changes_rounded,
              size: 38,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: NexusSpacing.lg),
          Text('Defina seu limite mensal', style: theme.textTheme.titleLarge),
          const SizedBox(height: NexusSpacing.sm),
          Text(
            'Você já registrou ${expenses.format()} em despesas neste mês.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: NexusSpacing.xl),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Definir limite'),
          ),
        ],
      ),
    );
  }
}

class MonthlyPlanCard extends StatelessWidget {
  const MonthlyPlanCard({
    super.key,
    required this.plan,
    required this.summary,
    required this.onEdit,
    required this.onRemove,
  });

  final MonthlySpendingPlan plan;
  final MonthlyPlanSummary summary;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final statusColor = summary.isOverBudget ? colors.error : colors.primary;
    final percentage = (summary.percentageUsed * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NexusCard(
          padding: const EdgeInsets.all(NexusSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Limite mensal',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Opções do limite',
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'remove') {
                        onRemove();
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 12),
                            Text('Ajustar limite'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded),
                            SizedBox(width: 12),
                            Text('Remover limite'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                plan.limit.format(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: NexusSpacing.xl),
              LinearProgressIndicator(
                value: summary.progress,
                minHeight: 12,
                borderRadius: BorderRadius.circular(999),
                color: statusColor,
                backgroundColor: colors.surfaceContainerHighest,
              ),
              const SizedBox(height: NexusSpacing.sm),
              Text(
                '$percentage% do limite utilizado',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: NexusSpacing.md),
        Row(
          children: [
            Expanded(
              child: _PlanMetricCard(
                label: 'Gasto no mês',
                value: summary.expenses.format(),
                icon: Icons.payments_outlined,
                color: colors.error,
              ),
            ),
            const SizedBox(width: NexusSpacing.md),
            Expanded(
              child: _PlanMetricCard(
                label: summary.isOverBudget ? 'Ultrapassou' : 'Disponível',
                value: summary.isOverBudget
                    ? summary.exceededBy.format()
                    : summary.remaining.format(),
                icon: summary.isOverBudget
                    ? Icons.warning_amber_rounded
                    : Icons.savings_outlined,
                color: statusColor,
              ),
            ),
          ],
        ),
        if (summary.isOverBudget) ...[
          const SizedBox(height: NexusSpacing.md),
          NexusCard(
            color: colors.errorContainer,
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: colors.onErrorContainer,
                ),
                const SizedBox(width: NexusSpacing.sm),
                Expanded(
                  child: Text(
                    'Seu limite foi ultrapassado em ${summary.exceededBy.format()}.',
                    style: TextStyle(color: colors.onErrorContainer),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _PlanMetricCard extends StatelessWidget {
  const _PlanMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return NexusCard(
      padding: const EdgeInsets.all(NexusSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: NexusSpacing.md),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: NexusSpacing.xs),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
