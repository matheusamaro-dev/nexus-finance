import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/components/nexus_card.dart';
import '../../../../core/design_system/components/nexus_empty_state.dart';
import '../../../../core/design_system/nexus_spacing.dart';
import '../../../../core/money/money.dart';
import '../../../transactions/application/providers/transactions_providers.dart';
import '../../../transactions/domain/entities/financial_transaction.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../application/providers/recurring_bills_providers.dart';
import '../../domain/entities/recurring_bill.dart';
import 'recurring_bill_form_page.dart';

class RecurringBillsPage extends ConsumerWidget {
  const RecurringBillsPage({super.key, this.referenceDate});

  final DateTime? referenceDate;

  Future<void> _openForm(BuildContext context, [RecurringBill? bill]) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => RecurringBillFormPage(bill: bill)),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    RecurringBill bill,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir conta recorrente'),
        content: Text(
          'Excluir "${bill.description}"? Os lançamentos já registrados serão mantidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await ref.read(recurringBillsRepositoryProvider).delete(bill.id);
  }

  Future<void> _registerPayment(
    BuildContext context,
    WidgetRef ref,
    RecurringBill bill,
    DateTime month,
  ) async {
    final now = DateTime.now();
    final transaction = FinancialTransaction(
      id: bill.transactionIdFor(month),
      description: bill.description,
      amount: bill.amount,
      type: TransactionType.expense,
      date: bill.dueDateFor(month),
      createdAt: now,
      category: bill.category,
      notes: 'Registrado a partir de uma conta recorrente.',
    );

    await ref.read(transactionsRepositoryProvider).save(transaction);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${bill.description} registrada neste mês.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = referenceDate ?? DateTime.now();
    final billsAsync = ref.watch(recurringBillsStreamProvider);
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final paidIds =
        transactionsAsync.valueOrNull
            ?.map((transaction) => transaction.id)
            .toSet() ??
        const <String>{};

    return Scaffold(
      appBar: AppBar(title: const Text('Contas recorrentes')),
      body: SafeArea(
        child: billsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => NexusEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Não foi possível carregar suas contas',
            message: 'Tente novamente em instantes.',
            action: OutlinedButton.icon(
              onPressed: () => ref.invalidate(recurringBillsStreamProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ),
          data: (bills) {
            if (bills.isEmpty) {
              return NexusEmptyState(
                icon: Icons.event_repeat_rounded,
                title: 'Nenhuma conta recorrente',
                message:
                    'Cadastre energia, internet, condomínio e outras contas mensais.',
                action: FilledButton.icon(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Cadastrar conta'),
                ),
              );
            }

            var monthlyTotal = const Money.zero();
            for (final bill in bills.where((bill) => bill.isActive)) {
              monthlyTotal += bill.amount;
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                NexusSpacing.lg,
                NexusSpacing.md,
                NexusSpacing.lg,
                100,
              ),
              children: [
                NexusCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Compromisso mensal',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: NexusSpacing.xs),
                      Text(
                        monthlyTotal.format(),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: NexusSpacing.xs),
                      Text('${bills.length} contas cadastradas'),
                    ],
                  ),
                ),
                const SizedBox(height: NexusSpacing.lg),
                for (final bill in bills) ...[
                  _RecurringBillCard(
                    bill: bill,
                    month: month,
                    isPaid: paidIds.contains(bill.transactionIdFor(month)),
                    onEdit: () => _openForm(context, bill),
                    onDelete: () => _delete(context, ref, bill),
                    onRegister: () =>
                        _registerPayment(context, ref, bill, month),
                  ),
                  const SizedBox(height: NexusSpacing.md),
                ],
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nova conta'),
      ),
    );
  }
}

class _RecurringBillCard extends StatelessWidget {
  const _RecurringBillCard({
    required this.bill,
    required this.month,
    required this.isPaid,
    required this.onEdit,
    required this.onDelete,
    required this.onRegister,
  });

  final RecurringBill bill;
  final DateTime month;
  final bool isPaid;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dueDate = bill.dueDateFor(month);

    return NexusCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: colors.primaryContainer,
                child: Icon(Icons.event_repeat_rounded, color: colors.primary),
              ),
              const SizedBox(width: NexusSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.description,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: NexusSpacing.xxs),
                    Text(
                      '${bill.category ?? 'Sem categoria'} • vence dia ${dueDate.day}',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Excluir')),
                ],
              ),
            ],
          ),
          const SizedBox(height: NexusSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  bill.amount.format(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              if (isPaid)
                Chip(
                  avatar: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Registrada'),
                )
              else
                FilledButton.tonalIcon(
                  onPressed: onRegister,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Registrar'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
