import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'daos/monthly_spending_plans_dao.dart';
import 'daos/recurring_bills_dao.dart';
import 'daos/transactions_dao.dart';
import 'tables/monthly_spending_plans_table.dart';
import 'tables/recurring_bills_table.dart';
import 'tables/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Transactions, MonthlySpendingPlans, RecurringBills],
  daos: [TransactionsDao, MonthlySpendingPlansDao, RecurringBillsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(monthlySpendingPlans);
      }
      if (from < 3) {
        await migrator.createTable(recurringBills);
      }
    },
  );

  Future<void> clearAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final databaseFile = File(
      path.join(directory.path, 'nexus_finance.sqlite'),
    );

    return NativeDatabase.createInBackground(databaseFile);
  });
}
