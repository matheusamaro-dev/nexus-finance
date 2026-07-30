enum TransactionType {
  income,
  expense;

  String get databaseValue => name;

  static TransactionType fromDatabase(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw ArgumentError.value(
        value,
        'value',
        'Tipo de lançamento inválido',
      ),
    );
  }
}
