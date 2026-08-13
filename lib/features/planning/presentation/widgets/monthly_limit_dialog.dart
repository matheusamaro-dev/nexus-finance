import 'package:flutter/material.dart';

import '../../../../core/money/money.dart';
import '../../domain/entities/monthly_spending_plan.dart';

class MonthlyLimitDialog extends StatefulWidget {
  const MonthlyLimitDialog({super.key, this.existingPlan});

  final MonthlySpendingPlan? existingPlan;

  @override
  State<MonthlyLimitDialog> createState() => _MonthlyLimitDialogState();
}

class _MonthlyLimitDialogState extends State<MonthlyLimitDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.existingPlan?.limit.reais
          .toStringAsFixed(2)
          .replaceAll('.', ','),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Money? _parseLimit(String? value) {
    final normalized = value?.trim().replaceAll('.', '').replaceAll(',', '.');
    final parsed = num.tryParse(normalized ?? '');

    if (parsed == null || parsed <= 0) {
      return null;
    }

    return Money.fromReais(parsed);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(_parseLimit(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingPlan != null;

    return AlertDialog(
      title: Text(
        isEditing ? 'Ajustar limite mensal' : 'Definir limite mensal',
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          key: const ValueKey('monthly-limit-field'),
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
          decoration: const InputDecoration(
            labelText: 'Limite de gastos',
            hintText: '0,00',
            prefixText: 'R\$ ',
            prefixIcon: Icon(Icons.savings_outlined),
          ),
          validator: (value) {
            if (_parseLimit(value) == null) {
              return 'Informe um valor válido';
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Salvar limite')),
      ],
    );
  }
}
