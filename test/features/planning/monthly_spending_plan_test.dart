import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_finance/core/database/app_database.dart';
import 'package:nexus_finance/core/money/money.dart';
import 'package:nexus_finance/features/planning/application/providers/planning_providers.dart';
import 'package:nexus_finance/features/planning/data/repositories/drift_monthly_spending_plans_repository.dart';
import 'package:nexus_finance/features/planning/domain/entities/monthly_spending_plan.dart';
import 'package:nexus_finance/features/planning/domain/repositories/monthly_spending_plans_repository.dart';
import 'package:nexus_finance/features/planning/presentation/models/monthly_plan_summary.dart';
import 'package:nexus_finance/features/planning/presentation/planning_page.dart';
import 'package:nexus_finance/features/transactions/application/providers/transactions_providers.dart';
import 'package:nexus_finance/features/transactions/domain/entities/financial_transaction.dart';
import 'package:nexus_finance/features/transactions/domain/entities/transaction_type.dart';

void main() {
  test('calcula o progresso e o valor disponível', () {
    final summary = MonthlyPlanSummary(
      limit: Money.fromCents(100000),
      expenses: Money.fromCents(35000),
    );

    expect(summary.percentageUsed, 0.35);
    expect(summary.progress, 0.35);
    expect(summary.remaining, Money.fromCents(65000));
    expect(summary.isOverBudget, isFalse);
  });

  test('identifica quando o limite foi ultrapassado', () {
    final summary = MonthlyPlanSummary(
      limit: Money.fromCents(50000),
      expenses: Money.fromCents(60000),
    );

    expect(summary.percentageUsed, 1.2);
    expect(summary.progress, 1);
    expect(summary.exceededBy, Money.fromCents(10000));
    expect(summary.isOverBudget, isTrue);
  });

  test('salva e recupera um limite no banco local', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = DriftMonthlySpendingPlansRepository(database);
    final plan = MonthlySpendingPlan.forMonth(
      month: DateTime(2026, 8),
      limit: Money.fromCents(120000),
      updatedAt: DateTime(2026, 8, 13),
    );

    addTearDown(database.close);

    await repository.save(plan);
    final saved = await repository.watchForMonth(2026, 8).first;

    expect(saved?.id, '2026-08');
    expect(saved?.limit, Money.fromCents(120000));
  });

  testWidgets('permite definir o limite mensal', (tester) async {
    final repository = _FakeMonthlySpendingPlansRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monthlySpendingPlansRepositoryProvider.overrideWithValue(repository),
          transactionsStreamProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          home: PlanningPage(initialReferenceDate: DateTime(2026, 8)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Definir limite'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('monthly-limit-field')),
      '1.200,00',
    );
    await tester.tap(find.text('Salvar limite'));
    await tester.pumpAndSettle();

    expect(repository.savedPlans, hasLength(1));
    expect(repository.savedPlans.single.id, '2026-08');
    expect(repository.savedPlans.single.limit, Money.fromCents(120000));
  });

  testWidgets('mostra o alerta quando os gastos ultrapassam o limite', (
    tester,
  ) async {
    final plan = MonthlySpendingPlan.forMonth(
      month: DateTime(2026, 8),
      limit: Money.fromCents(50000),
      updatedAt: DateTime(2026, 8, 13),
    );
    final repository = _FakeMonthlySpendingPlansRepository(plan);
    final expense = FinancialTransaction(
      id: 'expense-1',
      description: 'Mercado',
      amount: Money.fromCents(60000),
      type: TransactionType.expense,
      date: DateTime(2026, 8, 10),
      createdAt: DateTime(2026, 8, 10),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monthlySpendingPlansRepositoryProvider.overrideWithValue(repository),
          transactionsStreamProvider.overrideWith(
            (ref) => Stream.value([expense]),
          ),
        ],
        child: MaterialApp(
          home: PlanningPage(initialReferenceDate: DateTime(2026, 8)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('120% do limite utilizado'), findsOneWidget);
    expect(find.text('Ultrapassou'), findsOneWidget);
    expect(find.textContaining('Seu limite foi ultrapassado'), findsOneWidget);
  });
}

final class _FakeMonthlySpendingPlansRepository
    implements MonthlySpendingPlansRepository {
  _FakeMonthlySpendingPlansRepository([this.plan]);

  MonthlySpendingPlan? plan;
  final List<MonthlySpendingPlan> savedPlans = [];
  final List<String> deletedIds = [];

  @override
  Future<void> delete(String id) async {
    deletedIds.add(id);
    plan = null;
  }

  @override
  Future<void> save(MonthlySpendingPlan plan) async {
    savedPlans.add(plan);
    this.plan = plan;
  }

  @override
  Stream<MonthlySpendingPlan?> watchForMonth(int year, int month) {
    final selectedPlan = plan;

    if (selectedPlan?.year == year && selectedPlan?.month == month) {
      return Stream.value(selectedPlan);
    }

    return Stream.value(null);
  }
}
