import 'package:flutter/material.dart';

import '../nexus_colors.dart';
import '../nexus_radius.dart';
import '../nexus_spacing.dart';

enum NexusStatusChipType { success, error, warning, info, neutral }

class NexusStatusChip extends StatelessWidget {
  const NexusStatusChip({
    super.key,
    required this.label,
    this.icon,
    this.type = NexusStatusChipType.neutral,
  });

  final String label;
  final IconData? icon;
  final NexusStatusChipType type;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = _resolveAccent(colors);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NexusSpacing.sm,
        vertical: NexusSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(NexusRadius.pill),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: accent),
            const SizedBox(width: NexusSpacing.xs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color _resolveAccent(ColorScheme colors) {
    return switch (type) {
      NexusStatusChipType.success => NexusColors.income,
      NexusStatusChipType.error => NexusColors.expense,
      NexusStatusChipType.warning => NexusColors.warning,
      NexusStatusChipType.info => NexusColors.info,
      NexusStatusChipType.neutral => colors.onSurfaceVariant,
    };
  }
}
