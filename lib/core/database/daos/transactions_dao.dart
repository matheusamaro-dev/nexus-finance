import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transactions_table.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.database);

  Stream<List<Transaction>> watchAll() {
    return (select(transactions)..orderBy([
          (table) => OrderingTerm.desc(table.date),
          (table) => OrderingTerm.desc(table.createdAt),
        ]))
        .watch();
  }

  Future<List<Transaction>> getAll() {
    return (select(transactions)..orderBy([
          (table) => OrderingTerm.desc(table.date),
          (table) => OrderingTerm.desc(table.createdAt),
        ]))
        .get();
  }

  Future<void> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insertOnConflictUpdate(transaction);
  }

  Future<bool> updateTransaction(TransactionsCompanion transaction) {
    return update(transactions).replace(transaction);
  }

  Future<int> deleteById(String id) {
    return (delete(transactions)..where((table) => table.id.equals(id))).go();
  }
}
