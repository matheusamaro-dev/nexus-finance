import '../../../../core/money/money.dart';

final class MonthlyPlanSummary {
  const MonthlyPlanSummary({required this.limit, required this.expenses});

  final Money limit;
  final Money expenses;

  Money get remaining => limit - expenses;

  Money get exceededBy => expenses - limit;

  bool get isOverBudget => expenses.compareTo(limit) > 0;

  double get percentageUsed {
    if (limit.cents <= 0) {
      return 0;
    }

    return expenses.cents / limit.cents;
  }

  double get progress => percentageUsed.clamp(0, 1).toDouble();
}
