import 'package:flutter/material.dart';

import '../nexus_spacing.dart';
import 'nexus_card.dart';

class NexusEmptyState extends StatelessWidget {
  const NexusEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return NexusCard(
      padding: const EdgeInsets.all(NexusSpacing.xl),
      child: Column(
        children: [
          Icon(icon, size: 42, color: colors.primary),
          const SizedBox(height: NexusSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: NexusSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: NexusSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}
