import 'package:flutter/material.dart';

import '../../../../core/design_system/nexus_spacing.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/branding/nexus_app_icon.png',
            width: 52,
            height: 52,
            semanticLabel: 'Símbolo do Nexus Finance',
            fit: BoxFit.cover,
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
