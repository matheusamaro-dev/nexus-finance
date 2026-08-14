import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_finance/core/database/app_database.dart'
    hide RecurringBill;
import 'package:nexus_finance/core/money/money.dart';
import 'package:nexus_finance/features/recurring_bills/data/repositories/drift_recurring_bills_repository.dart';
import 'package:nexus_finance/features/recurring_bills/domain/entities/recurring_bill.dart';

void main() {
  RecurringBill createBill({int dueDay = 10}) {
    return RecurringBill(
      id: 'energy',
      description: 'Energia',
      amount: Money.fromCents(40246),
      dueDay: dueDay,
      category: 'Moradia',
      createdAt: DateTime(2026, 8, 13),
      updatedAt: DateTime(2026, 8, 13),
    );
  }

  test('ajusta vencimento 31 para o último dia de um mês curto', () {
    final bill = createBill(dueDay: 31);

    expect(bill.dueDateFor(DateTime(2026, 2)), DateTime(2026, 2, 28));
    expect(bill.dueDateFor(DateTime(2026, 4)), DateTime(2026, 4, 30));
  });

  test('gera um identificador mensal estável para evitar duplicidade', () {
    final bill = createBill();

    expect(
      bill.transactionIdFor(DateTime(2026, 8)),
      'recurring:energy:2026-08',
    );
  });

  test('salva e recupera contas recorrentes no banco local', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = DriftRecurringBillsRepository(database);
    final bill = createBill();

    addTearDown(database.close);

    await repository.save(bill);
    final saved = await repository.watchAll().first;

    expect(saved, hasLength(1));
    expect(saved.single.description, 'Energia');
    expect(saved.single.amount, Money.fromCents(40246));
    expect(saved.single.dueDay, 10);
  });
}
