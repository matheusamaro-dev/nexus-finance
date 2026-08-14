import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactions/application/providers/transactions_providers.dart';
import '../../data/repositories/drift_recurring_bills_repository.dart';
import '../../domain/entities/recurring_bill.dart';
import '../../domain/repositories/recurring_bills_repository.dart';

final recurringBillsRepositoryProvider = Provider<RecurringBillsRepository>((
  ref,
) {
  return DriftRecurringBillsRepository(ref.watch(appDatabaseProvider));
});

final recurringBillsStreamProvider = StreamProvider<List<RecurringBill>>((ref) {
  return ref.watch(recurringBillsRepositoryProvider).watchAll();
});
