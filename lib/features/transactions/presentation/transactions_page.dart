import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/transactions_providers.dart';
import '../domain/entities/financial_transaction.dart';
import '../domain/entities/transaction_type.dart';
import 'pages/new_transaction_page.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  Future<void> _openNewTransaction(BuildContext context) async {
    await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const NewTransactionPage()));
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    FinancialTransaction transaction,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir lançamento'),
          content: Text('Deseja excluir "${transaction.description}"?'),
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
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(transactionsRepositoryProvider).delete(transaction.id);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lançamento excluído.')));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível excluir o lançamento.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lançamentos')),
      body: SafeArea(
        child: transactionsAsync.when(
          data: (transactions) {
            if (transactions.isEmpty) {
              return _EmptyTransactionsState(
                onAddPressed: () => _openNewTransaction(context),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(transactionsStreamProvider);
              },
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: transactions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];

                  return _TransactionCard(
                    transaction: transaction,
                    onDelete: () {
                      _confirmDelete(context, ref, transaction);
                    },
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _TransactionsErrorState(
            onRetry: () {
              ref.invalidate(transactionsStreamProvider);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewTransaction(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Novo'),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction, required this.onDelete});

  final FinancialTransaction transaction;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isIncome = transaction.type == TransactionType.income;

    final accentColor = isIncome ? Colors.greenAccent.shade400 : colors.error;

    final icon = isIncome ? Icons.south_west_rounded : Icons.north_east_rounded;

    final typeLabel = isIncome ? 'Receita' : 'Despesa';
    final category = _normalizedCategory(transaction.category);
    final date = _formatDate(transaction.date);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accentColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _TransactionChip(
                          label: typeLabel,
                          icon: isIncome
                              ? Icons.add_rounded
                              : Icons.remove_rounded,
                          color: accentColor,
                        ),
                        if (category != null)
                          _TransactionChip(
                            label: category,
                            icon: _categoryIcon(category),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 82, maxWidth: 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isIncome ? '+' : '-'} ${transaction.amount.format()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PopupMenuButton<String>(
                      tooltip: 'Mais opções',
                      onSelected: (value) {
                        if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded),
                              SizedBox(width: 12),
                              Text('Excluir'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String? _normalizedCategory(String? category) {
    final normalized = category?.trim();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  static IconData _categoryIcon(String category) {
    final normalized = category.toLowerCase();

    if (normalized.contains('moradia') ||
        normalized.contains('casa') ||
        normalized.contains('aluguel')) {
      return Icons.home_outlined;
    }

    if (normalized.contains('aliment') ||
        normalized.contains('mercado') ||
        normalized.contains('restaurante')) {
      return Icons.restaurant_outlined;
    }

    if (normalized.contains('transport') ||
        normalized.contains('combust') ||
        normalized.contains('uber')) {
      return Icons.directions_car_outlined;
    }

    if (normalized.contains('saúde') ||
        normalized.contains('saude') ||
        normalized.contains('farmácia') ||
        normalized.contains('farmacia')) {
      return Icons.health_and_safety_outlined;
    }

    if (normalized.contains('salário') ||
        normalized.contains('salario') ||
        normalized.contains('renda')) {
      return Icons.payments_outlined;
    }

    if (normalized.contains('lazer') || normalized.contains('entretenimento')) {
      return Icons.movie_outlined;
    }

    if (normalized.contains('educação') ||
        normalized.contains('educacao') ||
        normalized.contains('curso')) {
      return Icons.school_outlined;
    }

    return Icons.sell_outlined;
  }
}

class _TransactionChip extends StatelessWidget {
  const _TransactionChip({required this.label, required this.icon, this.color});

  final String label;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foregroundColor = color ?? colors.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: foregroundColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTransactionsState extends StatelessWidget {
  const _EmptyTransactionsState({required this.onAddPressed});

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 52,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum lançamento cadastrado',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cadastre sua primeira receita ou despesa para iniciar o controle financeiro.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Adicionar lançamento'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionsErrorState extends StatelessWidget {
  const _TransactionsErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar os lançamentos',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Verifique os dados locais e tente novamente.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
