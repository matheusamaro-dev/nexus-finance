import 'package:flutter/material.dart';

import '../../../../core/design_system/nexus_radius.dart';
import '../../../../core/design_system/nexus_spacing.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(NexusRadius.lg),
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: colors.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: NexusSpacing.md),
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
              SizedBox(height: NexusSpacing.xxs),
              Text(
                'Olá, Matheus',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notificações',
          onPressed: null,
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}
