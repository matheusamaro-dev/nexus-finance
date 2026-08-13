import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../domain/entities/monthly_spending_plan.dart';

abstract final class MonthlySpendingPlanMapper {
  static MonthlySpendingPlan toDomain(MonthlySpendingPlanRow row) {
    return MonthlySpendingPlan(
      id: row.id,
      year: row.year,
      month: row.month,
      limit: Money.fromCents(row.limitCents),
      updatedAt: row.updatedAt,
    );
  }

  static MonthlySpendingPlansCompanion toCompanion(MonthlySpendingPlan plan) {
    return MonthlySpendingPlansCompanion(
      id: Value(plan.id),
      year: Value(plan.year),
      month: Value(plan.month),
      limitCents: Value(plan.limit.cents),
      updatedAt: Value(plan.updatedAt),
    );
  }
}
