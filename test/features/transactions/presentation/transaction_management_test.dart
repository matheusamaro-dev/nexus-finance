import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_finance/core/money/money.dart';
import 'package:nexus_finance/features/transactions/application/providers/transactions_providers.dart';
import 'package:nexus_finance/features/transactions/domain/entities/financial_transaction.dart';
import 'package:nexus_finance/features/transactions/domain/entities/transaction_type.dart';
import 'package:nexus_finance/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:nexus_finance/features/transactions/presentation/pages/new_transaction_page.dart';
import 'package:nexus_finance/features/transactions/presentation/transactions_page.dart';

void main() {
  final existingTransaction = FinancialTransaction(
    id: 'transaction-1',
    description: 'Energia EDP',
    amount: Money.fromCents(40226),
    type: TransactionType.expense,
    date: DateTime(2026, 8, 10),
    createdAt: DateTime(2026, 8, 10, 9),
    category: 'Moradia',
    notes: 'Conta de agosto',
  );

  testWidgets('edita um lançamento preservando sua identidade', (tester) async {
    final repository = _FakeTransactionsRepository([existingTransaction]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          home: NewTransactionPage(transaction: existingTransaction),
        ),
      ),
    );

    expect(find.text('Editar lançamento'), findsOneWidget);
    expect(find.text('Energia EDP'), findsOneWidget);
    expect(find.text('402,26'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Energia atualizada',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '430,50');

    final saveButton = find.text('Salvar alterações');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(repository.savedTransactions, hasLength(1));
    final saved = repository.savedTransactions.single;
    expect(saved.id, existingTransaction.id);
    expect(saved.createdAt, existingTransaction.createdAt);
    expect(saved.description, 'Energia atualizada');
    expect(saved.amount, Money.fromCents(43050));
  });

  testWidgets('abre a edição ao tocar em um lançamento', (tester) async {
    final repository = _FakeTransactionsRepository([existingTransaction]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: TransactionsPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Energia EDP'));
    await tester.pumpAndSettle();

    expect(find.text('Editar lançamento'), findsOneWidget);
    expect(find.text('Salvar alterações'), findsOneWidget);
  });

  testWidgets('permite desfazer a exclusão de um lançamento', (tester) async {
    final repository = _FakeTransactionsRepository([existingTransaction]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: TransactionsPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Mais opções'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Excluir'));
    await tester.pumpAndSettle();

    expect(repository.deletedIds, [existingTransaction.id]);
    expect(find.text('Desfazer'), findsOneWidget);

    await tester.tap(find.text('Desfazer'));
    await tester.pumpAndSettle();

    expect(repository.savedTransactions, [existingTransaction]);
  });
}

final class _FakeTransactionsRepository implements TransactionsRepository {
  _FakeTransactionsRepository(this.transactions);

  final List<FinancialTransaction> transactions;
  final List<FinancialTransaction> savedTransactions = [];
  final List<String> deletedIds = [];

  @override
  Future<void> delete(String id) async {
    deletedIds.add(id);
  }

  @override
  Future<List<FinancialTransaction>> getAll() async => transactions;

  @override
  Future<void> save(FinancialTransaction transaction) async {
    savedTransactions.add(transaction);
  }

  @override
  Stream<List<FinancialTransaction>> watchAll() => Stream.value(transactions);
}
