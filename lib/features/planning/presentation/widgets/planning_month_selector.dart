import 'package:flutter/material.dart';

class PlanningMonthSelector extends StatelessWidget {
  const PlanningMonthSelector({
    super.key,
    required this.referenceDate,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime referenceDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton.outlined(
          tooltip: 'Mês anterior',
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            _formatMonthYear(referenceDate),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
        ),
        IconButton.outlined(
          tooltip: 'Próximo mês',
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }

  static String _formatMonthYear(DateTime date) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return '${months[date.month - 1]} de ${date.year}';
  }
}
