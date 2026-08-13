import '../../../../core/database/app_database.dart';
import '../../domain/entities/monthly_spending_plan.dart';
import '../../domain/repositories/monthly_spending_plans_repository.dart';
import '../mappers/monthly_spending_plan_mapper.dart';

final class DriftMonthlySpendingPlansRepository
    implements MonthlySpendingPlansRepository {
  DriftMonthlySpendingPlansRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<MonthlySpendingPlan?> watchForMonth(int year, int month) {
    return _database.monthlySpendingPlansDao
        .watchForMonth(year, month)
        .map(
          (row) => row == null ? null : MonthlySpendingPlanMapper.toDomain(row),
        );
  }

  @override
  Future<void> save(MonthlySpendingPlan plan) {
    return _database.monthlySpendingPlansDao.save(
      MonthlySpendingPlanMapper.toCompanion(plan),
    );
  }

  @override
  Future<void> delete(String id) {
    return _database.monthlySpendingPlansDao.deleteById(id);
  }
}
