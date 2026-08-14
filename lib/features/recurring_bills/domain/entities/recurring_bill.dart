import '../../../../core/money/money.dart';

final class RecurringBill {
  const RecurringBill({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDay,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.isActive = true,
  }) : assert(dueDay >= 1 && dueDay <= 31);

  final String id;
  final String description;
  final Money amount;
  final int dueDay;
  final String? category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  DateTime dueDateFor(DateTime referenceDate) {
    final lastDay = DateTime(
      referenceDate.year,
      referenceDate.month + 1,
      0,
    ).day;

    return DateTime(
      referenceDate.year,
      referenceDate.month,
      dueDay > lastDay ? lastDay : dueDay,
    );
  }

  String transactionIdFor(DateTime referenceDate) {
    final month = referenceDate.month.toString().padLeft(2, '0');
    return 'recurring:$id:${referenceDate.year}-$month';
  }

  RecurringBill copyWith({
    String? id,
    String? description,
    Money? amount,
    int? dueDay,
    String? category,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecurringBill(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dueDay: dueDay ?? this.dueDay,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
