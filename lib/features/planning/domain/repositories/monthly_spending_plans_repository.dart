import '../entities/monthly_spending_plan.dart';

abstract interface class MonthlySpendingPlansRepository {
  Stream<MonthlySpendingPlan?> watchForMonth(int year, int month);

  Future<void> save(MonthlySpendingPlan plan);

  Future<void> delete(String id);
}
