import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/theme/app_theme.dart';

class GuestBanner extends StatelessWidget {
  const GuestBanner({super.key});
  @override
  Widget build(BuildContext context) {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null || !u.isAnonymous) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.ambra.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.ambra.withValues(alpha: 0.5)),
      ),
      child: Row(children: [
        const Icon(Icons.info_outline, color: AppTheme.terra),
        const SizedBox(width: 8),
        Expanded(child: Text('Sei in Modalità Ospite: i dati inseriti sono temporanei.',
            style: const TextStyle(fontSize: 13, color: AppTheme.terra))),
        TextButton(onPressed: () => context.push('/login'), child: const Text('Accedi')),
      ]),
    );
  }
}
