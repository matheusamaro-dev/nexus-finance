import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../domain/entities/financial_transaction.dart';
import '../../domain/entities/transaction_type.dart';

abstract final class TransactionMapper {
  static FinancialTransaction toDomain(Transaction row) {
    return FinancialTransaction(
      id: row.id,
      description: row.description,
      amount: Money.fromCents(row.amountCents),
      type: TransactionType.fromDatabase(row.type),
      date: row.date,
      createdAt: row.createdAt,
      category: row.category,
      notes: row.notes,
    );
  }

  static TransactionsCompanion toCompanion(FinancialTransaction transaction) {
    return TransactionsCompanion(
      id: Value(transaction.id),
      description: Value(transaction.description),
      amountCents: Value(transaction.amount.cents),
      type: Value(transaction.type.databaseValue),
      date: Value(transaction.date),
      createdAt: Value(transaction.createdAt),
      category: Value(transaction.category),
      notes: Value(transaction.notes),
    );
  }
}
