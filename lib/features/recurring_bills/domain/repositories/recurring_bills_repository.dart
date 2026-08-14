import '../entities/recurring_bill.dart';

abstract interface class RecurringBillsRepository {
  Stream<List<RecurringBill>> watchAll();

  Future<List<RecurringBill>> getAll();

  Future<void> save(RecurringBill bill);

  Future<void> delete(String id);
}
