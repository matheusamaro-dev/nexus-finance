import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/money/money.dart';
import '../../application/providers/recurring_bills_providers.dart';
import '../../domain/entities/recurring_bill.dart';

class RecurringBillFormPage extends ConsumerStatefulWidget {
  const RecurringBillFormPage({super.key, this.bill});

  final RecurringBill? bill;

  @override
  ConsumerState<RecurringBillFormPage> createState() =>
      _RecurringBillFormPageState();
}

class _RecurringBillFormPageState extends ConsumerState<RecurringBillFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _dueDayController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final bill = widget.bill;
    if (bill != null) {
      _descriptionController.text = bill.description;
      _amountController.text = bill.amount.reais
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      _dueDayController.text = bill.dueDay.toString();
      _categoryController.text = bill.category ?? '';
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _dueDayController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Money? _parseAmount(String? value) {
    final normalized = value?.trim().replaceAll('.', '').replaceAll(',', '.');
    final parsed = num.tryParse(normalized ?? '');
    return parsed == null || parsed <= 0 ? null : Money.fromReais(parsed);
  }

  int? _parseDueDay(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    return parsed != null && parsed >= 1 && parsed <= 31 ? parsed : null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final existing = widget.bill;
      final bill = RecurringBill(
        id: existing?.id ?? const Uuid().v4(),
        description: _descriptionController.text.trim(),
        amount: _parseAmount(_amountController.text)!,
        dueDay: _parseDueDay(_dueDayController.text)!,
        category: _categoryController.text.trim().isEmpty
            ? null
            : _categoryController.text.trim(),
        isActive: existing?.isActive ?? true,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );

      await ref.read(recurringBillsRepositoryProvider).save(bill);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível salvar a conta.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.bill != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar conta' : 'Nova conta recorrente'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                key: const ValueKey('recurring-description-field'),
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Ex.: Energia EDP',
                  prefixIcon: Icon(Icons.receipt_long_outlined),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Informe a descrição'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('recurring-amount-field'),
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Valor mensal',
                  hintText: '0,00',
                  prefixText: 'R\$ ',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                ),
                validator: (value) => _parseAmount(value) == null
                    ? 'Informe um valor válido'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('recurring-due-day-field'),
                controller: _dueDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Dia do vencimento',
                  hintText: '1 a 31',
                  prefixIcon: Icon(Icons.event_outlined),
                ),
                validator: (value) => _parseDueDay(value) == null
                    ? 'Informe um dia entre 1 e 31'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  hintText: 'Ex.: Moradia',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSaving ? 'Salvando...' : 'Salvar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
