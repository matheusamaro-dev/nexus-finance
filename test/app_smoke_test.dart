import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_finance/app/nexus_finance_app.dart';
import 'package:nexus_finance/features/transactions/application/providers/transactions_providers.dart';

void main() {
  testWidgets('exibe a identidade do Nexus Finance', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsStreamProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const NexusFinanceApp(),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('NEXUS FINANCE'), findsOneWidget);
    expect(find.bySemanticsLabel('Símbolo do Nexus Finance'), findsOneWidget);
    expect(find.text('Olá, Matheus'), findsOneWidget);
    expect(find.text('Saldo do mês'), findsOneWidget);
    expect(find.text('Nenhum lançamento neste mês'), findsOneWidget);
  });
}
