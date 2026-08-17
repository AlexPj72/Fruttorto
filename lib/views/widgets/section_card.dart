import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class SectionCard extends StatelessWidget {
  final String titolo;
  final Widget child;
  final VoidCallback? onTap;
  const SectionCard({super.key, required this.titolo, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titolo, style: AppTheme.titoloSezione),
            const SizedBox(height: 10),
            child,
          ]),
        ),
      ),
    );
  }
}
