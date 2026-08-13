import 'package:flutter/material.dart';

import '../../../../core/design_system/nexus_spacing.dart';

class QuickAction extends StatelessWidget {
  const QuickAction({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 24,
          padding: const EdgeInsets.all(NexusSpacing.md),
        ),
        const SizedBox(height: NexusSpacing.xs),
        Text(
          label,
          style: TextStyle(
            color: onPressed == null
                ? colors.onSurfaceVariant.withValues(alpha: 0.45)
                : colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
