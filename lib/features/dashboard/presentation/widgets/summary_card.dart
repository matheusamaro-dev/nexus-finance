import 'package:flutter/material.dart';

import '../../../../core/design_system/components/nexus_card.dart';
import '../../../../core/design_system/components/nexus_status_chip.dart';
import '../../../../core/design_system/nexus_colors.dart';
import '../../../../core/design_system/nexus_spacing.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
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
    final accent = positive ? NexusColors.income : NexusColors.expense;

    return NexusCard(
      padding: const EdgeInsets.all(NexusSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NexusStatusChip(
            label: title,
            icon: icon,
            type: positive
                ? NexusStatusChipType.success
                : NexusStatusChipType.error,
          ),
          const SizedBox(height: NexusSpacing.lg),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
