import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../domain/entities/recurring_bill.dart' as domain;

abstract final class RecurringBillMapper {
  static domain.RecurringBill toDomain(RecurringBill row) {
    return domain.RecurringBill(
      id: row.id,
      description: row.description,
      amount: Money.fromCents(row.amountCents),
      dueDay: row.dueDay,
      category: row.category,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static RecurringBillsCompanion toCompanion(domain.RecurringBill bill) {
    return RecurringBillsCompanion(
      id: Value(bill.id),
      description: Value(bill.description),
      amountCents: Value(bill.amount.cents),
      dueDay: Value(bill.dueDay),
      category: Value(bill.category),
      isActive: Value(bill.isActive),
      createdAt: Value(bill.createdAt),
      updatedAt: Value(bill.updatedAt),
    );
  }
}
