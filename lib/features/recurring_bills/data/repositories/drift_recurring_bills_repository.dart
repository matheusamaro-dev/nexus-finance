import '../../../../core/database/app_database.dart' hide RecurringBill;
import '../../domain/entities/recurring_bill.dart';
import '../../domain/repositories/recurring_bills_repository.dart';
import '../mappers/recurring_bill_mapper.dart';

final class DriftRecurringBillsRepository implements RecurringBillsRepository {
  DriftRecurringBillsRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<RecurringBill>> watchAll() {
    return _database.recurringBillsDao.watchAll().map(
      (rows) => rows.map(RecurringBillMapper.toDomain).toList(),
    );
  }

  @override
  Future<List<RecurringBill>> getAll() async {
    final rows = await _database.recurringBillsDao.getAll();
    return rows.map(RecurringBillMapper.toDomain).toList();
  }

  @override
  Future<void> save(RecurringBill bill) {
    return _database.recurringBillsDao.save(
      RecurringBillMapper.toCompanion(bill),
    );
  }

  @override
  Future<void> delete(String id) {
    return _database.recurringBillsDao.deleteById(id);
  }
}
