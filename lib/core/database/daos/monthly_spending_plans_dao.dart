import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/monthly_spending_plans_table.dart';

part 'monthly_spending_plans_dao.g.dart';

@DriftAccessor(tables: [MonthlySpendingPlans])
class MonthlySpendingPlansDao extends DatabaseAccessor<AppDatabase>
    with _$MonthlySpendingPlansDaoMixin {
  MonthlySpendingPlansDao(super.database);

  Stream<MonthlySpendingPlanRow?> watchForMonth(int year, int month) {
    return (select(monthlySpendingPlans)
          ..where((table) => table.year.equals(year))
          ..where((table) => table.month.equals(month)))
        .watchSingleOrNull();
  }

  Future<void> save(MonthlySpendingPlansCompanion plan) {
    return into(monthlySpendingPlans).insertOnConflictUpdate(plan);
  }

  Future<int> deleteById(String id) {
    return (delete(
      monthlySpendingPlans,
    )..where((table) => table.id.equals(id))).go();
  }
}
