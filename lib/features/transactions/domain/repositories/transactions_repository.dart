import '../entities/financial_transaction.dart';

abstract interface class TransactionsRepository {
  Stream<List<FinancialTransaction>> watchAll();

  Future<List<FinancialTransaction>> getAll();

  Future<void> save(FinancialTransaction transaction);

  Future<void> delete(String id);
}
