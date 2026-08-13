import 'package:drift/drift.dart';

@DataClassName('MonthlySpendingPlanRow')
class MonthlySpendingPlans extends Table {
  TextColumn get id => text()();

  IntColumn get year => integer()();

  IntColumn get month => integer()();

  IntColumn get limitCents => integer()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
