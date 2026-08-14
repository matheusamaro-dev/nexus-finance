import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/recurring_bills_table.dart';

part 'recurring_bills_dao.g.dart';

@DriftAccessor(tables: [RecurringBills])
class RecurringBillsDao extends DatabaseAccessor<AppDatabase>
    with _$RecurringBillsDaoMixin {
  RecurringBillsDao(super.database);

  Stream<List<RecurringBill>> watchAll() {
    return (select(recurringBills)..orderBy([
          (table) => OrderingTerm.desc(table.isActive),
          (table) => OrderingTerm.asc(table.dueDay),
          (table) => OrderingTerm.asc(table.description),
        ]))
        .watch();
  }

  Future<List<RecurringBill>> getAll() {
    return (select(recurringBills)..orderBy([
          (table) => OrderingTerm.desc(table.isActive),
          (table) => OrderingTerm.asc(table.dueDay),
          (table) => OrderingTerm.asc(table.description),
        ]))
        .get();
  }

  Future<void> save(RecurringBillsCompanion bill) {
    return into(recurringBills).insertOnConflictUpdate(bill);
  }

  Future<int> deleteById(String id) {
    return (delete(recurringBills)..where((table) => table.id.equals(id))).go();
  }
}
