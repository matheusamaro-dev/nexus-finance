import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactions/application/providers/transactions_providers.dart';
import '../../data/repositories/drift_monthly_spending_plans_repository.dart';
import '../../domain/entities/monthly_spending_plan.dart';
import '../../domain/repositories/monthly_spending_plans_repository.dart';

typedef PlanningMonth = ({int year, int month});

final monthlySpendingPlansRepositoryProvider =
    Provider<MonthlySpendingPlansRepository>((ref) {
      return DriftMonthlySpendingPlansRepository(
        ref.watch(appDatabaseProvider),
      );
    });

final monthlySpendingPlanProvider =
    StreamProvider.family<MonthlySpendingPlan?, PlanningMonth>((ref, month) {
      return ref
          .watch(monthlySpendingPlansRepositoryProvider)
          .watchForMonth(month.year, month.month);
    });
