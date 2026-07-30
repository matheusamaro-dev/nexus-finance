import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                Icon(Icons.settings_rounded, size: 58),
                SizedBox(height: 18),
                Text(
                  'Ajustes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Preferências, segurança e gerenciamento dos dados.',
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
