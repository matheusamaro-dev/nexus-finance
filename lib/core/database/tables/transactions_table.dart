import 'package:drift/drift.dart';

class Transactions extends Table {
  TextColumn get id => text()();

  TextColumn get description => text().withLength(min: 1, max: 160)();

  IntColumn get amountCents => integer()();

  TextColumn get type => text().withLength(min: 1, max: 20)();

  DateTimeColumn get date => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  TextColumn get category => text().nullable()();

  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
