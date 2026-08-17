import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final String emoji, testoTecnico, testoNarrativo;
  const EmptyState({super.key, required this.emoji, required this.testoTecnico, required this.testoNarrativo});

  @override
  Widget build(BuildContext context) {
    final nonFare = context.watch<SettingsProvider>().nonFare;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 44)),
        const SizedBox(height: 8),
        Text(nonFare ? testoNarrativo : testoTecnico,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.terra,
              fontStyle: nonFare ? FontStyle.italic : FontStyle.normal,
            )),
      ]),
    );
  }
}
