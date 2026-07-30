import 'package:flutter/material.dart';

class PlanningPage extends StatelessWidget {
  const PlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.insights_rounded, size: 58),
                SizedBox(height: 18),
                Text(
                  'Planejamento',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Projeções, metas e inteligência financeira.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text('Módulo em construção • v0.1.0'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
