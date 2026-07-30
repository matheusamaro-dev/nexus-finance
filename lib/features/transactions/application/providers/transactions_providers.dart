import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/drift_transactions_repository.dart';
import '../../domain/entities/financial_transaction.dart';
import '../../domain/repositories/transactions_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(database.close);

  return database;
});

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return DriftTransactionsRepository(ref.watch(appDatabaseProvider));
});

final transactionsStreamProvider = StreamProvider<List<FinancialTransaction>>((
  ref,
) {
  return ref.watch(transactionsRepositoryProvider).watchAll();
});
