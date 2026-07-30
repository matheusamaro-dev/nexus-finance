import '../../../../core/money/money.dart';
import 'transaction_type.dart';

final class FinancialTransaction {
  const FinancialTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.createdAt,
    this.category,
    this.notes,
  });

  final String id;
  final String description;
  final Money amount;
  final TransactionType type;
  final DateTime date;
  final DateTime createdAt;
  final String? category;
  final String? notes;

  FinancialTransaction copyWith({
    String? id,
    String? description,
    Money? amount,
    TransactionType? type,
    DateTime? date,
    DateTime? createdAt,
    String? category,
    String? notes,
  }) {
    return FinancialTransaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }
}
