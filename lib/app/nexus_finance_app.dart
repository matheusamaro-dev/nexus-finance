import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/planning/presentation/planning_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/transactions/presentation/transactions_page.dart';

class NexusFinanceApp extends StatelessWidget {
  const NexusFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Finance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const NexusFinanceShell(),
    );
  }
}

class NexusFinanceShell extends StatefulWidget {
  const NexusFinanceShell({super.key});

  @override
  State<NexusFinanceShell> createState() => _NexusFinanceShellState();
}

class _NexusFinanceShellState extends State<NexusFinanceShell> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    DashboardPage(),
    TransactionsPage(),
    PlanningPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            if (index == _selectedIndex) {
              return;
            }

            setState(() => _selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Lançamentos',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights_rounded),
              label: 'Planejamento',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}
