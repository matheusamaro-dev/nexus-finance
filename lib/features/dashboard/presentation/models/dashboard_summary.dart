import '../../../../core/money/money.dart';
import '../../../transactions/domain/entities/financial_transaction.dart';
import '../../../transactions/domain/entities/transaction_type.dart';

final class DashboardSummary {
  const DashboardSummary({
    required this.income,
    required this.expenses,
    required this.balance,
    required this.transactionCount,
    required this.recentTransactions,
  });

  factory DashboardSummary.fromTransactions(
    List<FinancialTransaction> transactions, {
    required DateTime referenceDate,
  }) {
    final monthlyTransactions = transactions.where((transaction) {
      return transaction.date.year == referenceDate.year &&
          transaction.date.month == referenceDate.month;
    }).toList();

    var income = const Money.zero();
    var expenses = const Money.zero();

    for (final transaction in monthlyTransactions) {
      switch (transaction.type) {
        case TransactionType.income:
          income += transaction.amount;
        case TransactionType.expense:
          expenses += transaction.amount;
      }
    }

    return DashboardSummary(
      income: income,
      expenses: expenses,
      balance: income - expenses,
      transactionCount: monthlyTransactions.length,
      recentTransactions: monthlyTransactions.take(3).toList(),
    );
  }

  final Money income;
  final Money expenses;
  final Money balance;
  final int transactionCount;
  final List<FinancialTransaction> recentTransactions;
}
