import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            sliver: SliverList.list(
              children: [
                Row(
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
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Notificações',
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Visão geral',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Julho de 2026',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                _BalanceCard(colors: colors),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Receitas',
                        value: 'R\$ 0,00',
                        icon: Icons.arrow_downward_rounded,
                        positive: true,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Despesas',
                        value: 'R\$ 0,00',
                        icon: Icons.arrow_upward_rounded,
                        positive: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Ações rápidas',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickAction(label: 'Receita', icon: Icons.add_rounded),
                    _QuickAction(label: 'Despesa', icon: Icons.remove_rounded),
                    _QuickAction(
                      label: 'Conta',
                      icon: Icons.calendar_month_rounded,
                    ),
                    _QuickAction(
                      label: 'Cartão',
                      icon: Icons.credit_card_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Próximos vencimentos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 38,
                          color: colors.primary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Nenhum vencimento cadastrado',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Suas contas e parcelas aparecerão aqui.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Center(
                  child: Text(
                    'Nexus Finance • Foundation v0.1.0',
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo projetado',
              style: TextStyle(
                color: colors.onPrimaryContainer.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ 0,00',
              style: TextStyle(
                color: colors.onPrimaryContainer,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: colors.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Dados armazenados no dispositivo',
                  style: TextStyle(
                    color: colors.onPrimaryContainer,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
    final colors = Theme.of(context).colorScheme;
    final accent = positive ? colors.primary : colors.error;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accent),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        IconButton.filledTonal(
          onPressed: () {},
          icon: Icon(icon),
          iconSize: 24,
          padding: const EdgeInsets.all(16),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
