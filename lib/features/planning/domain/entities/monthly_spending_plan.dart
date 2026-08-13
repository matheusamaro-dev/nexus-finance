import '../../../../core/money/money.dart';

final class MonthlySpendingPlan {
  const MonthlySpendingPlan({
    required this.id,
    required this.year,
    required this.month,
    required this.limit,
    required this.updatedAt,
  });

  factory MonthlySpendingPlan.forMonth({
    required DateTime month,
    required Money limit,
    required DateTime updatedAt,
  }) {
    return MonthlySpendingPlan(
      id: monthId(month),
      year: month.year,
      month: month.month,
      limit: limit,
      updatedAt: updatedAt,
    );
  }

  final String id;
  final int year;
  final int month;
  final Money limit;
  final DateTime updatedAt;

  static String monthId(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }
}
