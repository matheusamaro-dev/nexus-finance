import 'package:flutter/material.dart';

import '../../../../core/design_system/components/nexus_empty_state.dart';

class DashboardErrorState extends StatelessWidget {
  const DashboardErrorState({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return NexusEmptyState(
      icon: Icons.error_outline_rounded,
      title: 'Não foi possível carregar o resumo financeiro',
      message: 'Verifique os dados e tente carregar novamente.',
      action: OutlinedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Tentar novamente'),
      ),
    );
  }
}
