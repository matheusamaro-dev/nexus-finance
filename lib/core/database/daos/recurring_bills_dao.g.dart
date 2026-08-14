// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_bills_dao.dart';

// ignore_for_file: type=lint
mixin _$RecurringBillsDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecurringBillsTable get recurringBills => attachedDatabase.recurringBills;
  RecurringBillsDaoManager get managers => RecurringBillsDaoManager(this);
}

class RecurringBillsDaoManager {
  final _$RecurringBillsDaoMixin _db;
  RecurringBillsDaoManager(this._db);
  $$RecurringBillsTableTableManager get recurringBills =>
      $$RecurringBillsTableTableManager(
        _db.attachedDatabase,
        _db.recurringBills,
      );
}
