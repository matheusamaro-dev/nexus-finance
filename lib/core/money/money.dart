import 'package:intl/intl.dart';

/// Representa valores monetários usando centavos.
///
/// Nunca armazena dinheiro em double, evitando erros de precisão binária.
final class Money implements Comparable<Money> {
  const Money._(this.cents);

  const Money.zero() : cents = 0;

  factory Money.fromCents(int cents) => Money._(cents);

  factory Money.fromReais(num reais) {
    return Money._((reais * 100).round());
  }

  final int cents;

  bool get isZero => cents == 0;
  bool get isPositive => cents > 0;
  bool get isNegative => cents < 0;

  double get reais => cents / 100;

  Money operator +(Money other) => Money._(cents + other.cents);

  Money operator -(Money other) => Money._(cents - other.cents);

  Money operator -() => Money._(-cents);

  Money multiplyBy(int factor) => Money._(cents * factor);

  String format({String locale = 'pt_BR', String symbol = 'R\$'}) {
    return NumberFormat.currency(locale: locale, symbol: symbol).format(reais);
  }

  @override
  int compareTo(Money other) => cents.compareTo(other.cents);

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Money && other.cents == cents;
  }

  @override
  int get hashCode => cents.hashCode;

  @override
  String toString() => format();
}
