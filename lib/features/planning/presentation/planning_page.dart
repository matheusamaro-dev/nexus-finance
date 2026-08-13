import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/nexus_spacing.dart';
import '../../../core/money/money.dart';
import '../../transactions/application/providers/transactions_providers.dart';
import '../application/providers/planning_providers.dart';
import '../domain/entities/monthly_spending_plan.dart';
import 'widgets/monthly_limit_dialog.dart';
import 'widgets/planning_content.dart';
import 'widgets/planning_month_selector.dart';

class PlanningPage extends ConsumerStatefulWidget {
  const PlanningPage({super.key, this.initialReferenceDate});

  final DateTime? initialReferenceDate;

  @override
  ConsumerState<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends ConsumerState<PlanningPage> {
  late DateTime _referenceDate;

  PlanningMonth get _selectedMonth =>
      (year: _referenceDate.year, month: _referenceDate.month);

  @override
  void initState() {
    super.initState();
    final initialDate = widget.initialReferenceDate ?? DateTime.now();
    _referenceDate = DateTime(initialDate.year, initialDate.month);
  }

  void _changeMonth(int offset) {
    setState(() {
      _referenceDate = DateTime(
        _referenceDate.year,
        _referenceDate.month + offset,
      );
    });
  }

  Future<void> _editPlan(MonthlySpendingPlan? existingPlan) async {
    final limit = await showDialog<Money>(
      context: context,
      builder: (context) => MonthlyLimitDialog(existingPlan: existingPlan),
    );

    if (limit == null || !mounted) {
      return;
    }

    final plan = MonthlySpendingPlan.forMonth(
      month: _referenceDate,
      limit: limit,
      updatedAt: DateTime.now(),
    );

    try {
      await ref.read(monthlySpendingPlansRepositoryProvider).save(plan);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Limite mensal salvo.')));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o limite.')),
      );
    }
  }

  Future<void> _removePlan(MonthlySpendingPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remover limite mensal'),
        content: const Text(
          'Os lançamentos serão mantidos. Apenas o limite deste mês será removido.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    try {
      await ref.read(monthlySpendingPlansRepositoryProvider).delete(plan.id);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Limite mensal removido.')));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível remover o limite.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final planAsync = ref.watch(monthlySpendingPlanProvider(_selectedMonth));
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                NexusSpacing.lg,
                NexusSpacing.lg,
                NexusSpacing.lg,
                100,
              ),
              sliver: SliverList.list(
                children: [
                  Text('Planejamento', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: NexusSpacing.xs),
                  Text(
                    'Defina um limite e acompanhe seus gastos mês a mês.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: NexusSpacing.xl),
                  PlanningMonthSelector(
                    referenceDate: _referenceDate,
                    onPrevious: () => _changeMonth(-1),
                    onNext: () => _changeMonth(1),
                  ),
                  const SizedBox(height: NexusSpacing.xl),
                  PlanningContent(
                    planAsync: planAsync,
                    transactionsAsync: transactionsAsync,
                    referenceDate: _referenceDate,
                    onCreatePlan: () => _editPlan(null),
                    onEditPlan: _editPlan,
                    onRemovePlan: _removePlan,
                    onRetry: () {
                      ref.invalidate(
                        monthlySpendingPlanProvider(_selectedMonth),
                      );
                      ref.invalidate(transactionsStreamProvider);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
