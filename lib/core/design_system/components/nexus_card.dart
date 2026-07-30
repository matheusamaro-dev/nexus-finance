import 'package:flutter/material.dart';

import '../nexus_spacing.dart';

class NexusCard extends StatelessWidget {
  const NexusCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(NexusSpacing.lg),
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      color: color,
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) {
      return card;
    }

    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: card,
      ),
    );
  }
}
