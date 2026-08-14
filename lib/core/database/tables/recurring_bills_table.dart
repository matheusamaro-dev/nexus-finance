import 'package:drift/drift.dart';

class RecurringBills extends Table {
  TextColumn get id => text()();

  TextColumn get description => text().withLength(min: 1, max: 160)();

  IntColumn get amountCents => integer()();

  IntColumn get dueDay => integer()();

  TextColumn get category => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
