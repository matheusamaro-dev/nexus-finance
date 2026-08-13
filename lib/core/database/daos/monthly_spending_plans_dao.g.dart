// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_spending_plans_dao.dart';

// ignore_for_file: type=lint
mixin _$MonthlySpendingPlansDaoMixin on DatabaseAccessor<AppDatabase> {
  $MonthlySpendingPlansTable get monthlySpendingPlans =>
      attachedDatabase.monthlySpendingPlans;
  MonthlySpendingPlansDaoManager get managers =>
      MonthlySpendingPlansDaoManager(this);
}

class MonthlySpendingPlansDaoManager {
  final _$MonthlySpendingPlansDaoMixin _db;
  MonthlySpendingPlansDaoManager(this._db);
  $$MonthlySpendingPlansTableTableManager get monthlySpendingPlans =>
      $$MonthlySpendingPlansTableTableManager(
        _db.attachedDatabase,
        _db.monthlySpendingPlans,
      );
}
