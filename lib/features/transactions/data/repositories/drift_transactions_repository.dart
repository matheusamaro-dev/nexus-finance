import '../../../../core/database/app_database.dart';
import '../../domain/entities/financial_transaction.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../mappers/transaction_mapper.dart';

final class DriftTransactionsRepository implements TransactionsRepository {
  DriftTransactionsRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<FinancialTransaction>> watchAll() {
    return _database.transactionsDao.watchAll().map(
      (rows) => rows.map(TransactionMapper.toDomain).toList(),
    );
  }

  @override
  Future<List<FinancialTransaction>> getAll() async {
    final rows = await _database.transactionsDao.getAll();

    return rows.map(TransactionMapper.toDomain).toList();
  }

  @override
  Future<void> save(FinancialTransaction transaction) {
    return _database.transactionsDao.insertTransaction(
      TransactionMapper.toCompanion(transaction),
    );
  }

  @override
  Future<void> delete(String id) {
    return _database.transactionsDao.deleteById(id);
  }
}
