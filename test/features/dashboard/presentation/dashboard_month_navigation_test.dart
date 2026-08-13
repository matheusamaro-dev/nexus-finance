import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_finance/core/money/money.dart';
import 'package:nexus_finance/features/dashboard/presentation/dashboard_page.dart';
import 'package:nexus_finance/features/dashboard/presentation/models/dashboard_summary.dart';
import 'package:nexus_finance/features/transactions/application/providers/transactions_providers.dart';
import 'package:nexus_finance/features/transactions/domain/entities/financial_transaction.dart';
import 'package:nexus_finance/features/transactions/domain/entities/transaction_type.dart';

void main() {
  final julyIncome = FinancialTransaction(
    id: 'july-income',
    description: 'Salário de julho',
    amount: Money.fromCents(500000),
    type: TransactionType.income,
    date: DateTime(2026, 7, 30),
    createdAt: DateTime(2026, 7, 30, 9),
  );
  final augustExpense = FinancialTransaction(
    id: 'august-expense',
    description: 'Energia de agosto',
    amount: Money.fromCents(35000),
    type: TransactionType.expense,
    date: DateTime(2026, 8, 5),
    createdAt: DateTime(2026, 8, 5, 9),
  );

  test('mantém resumo e lançamentos no mesmo mês', () {
    final summary = DashboardSummary.fromTransactions([
      augustExpense,
      julyIncome,
    ], referenceDate: DateTime(2026, 8));

    expect(summary.income, const Money.zero());
    expect(summary.expenses, Money.fromCents(35000));
    expect(summary.transactionCount, 1);
    expect(summary.recentTransactions, [augustExpense]);
  });

  testWidgets('navega entre os meses do painel', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsStreamProvider.overrideWith(
            (ref) => Stream.value([augustExpense, julyIncome]),
          ),
        ],
        child: MaterialApp(
          home: DashboardPage(
            initialReferenceDate: DateTime(2026, 8),
            currentDate: DateTime(2026, 8),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Agosto de 2026'), findsOneWidget);
    expect(find.text('Energia de agosto'), findsOneWidget);
    expect(find.text('Salário de julho'), findsNothing);

    await tester.tap(find.byTooltip('Mês anterior'));
    await tester.pump();

    expect(find.text('Julho de 2026'), findsOneWidget);
    expect(find.text('Salário de julho'), findsOneWidget);
    expect(find.text('Energia de agosto'), findsNothing);
    expect(find.text('Voltar para o mês atual'), findsOneWidget);
  });
}
