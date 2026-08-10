import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:myapp/app_router.dart';
import 'package:myapp/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

// Importazioni per Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  // Garantisce l'inizializzazione dei widget Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializzazione di Firebase con le opzioni della piattaforma corrente
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Esecuzione del login anonimo in background
  try {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
      debugPrint("🎯 Login anonimo completato con successo!");
    } else {
      debugPrint("🌱 Utente già connesso come: ${auth.currentUser!.uid}");
    }
  } catch (e) {
    debugPrint("❌ Errore durante il login anonimo: $e");
  }

  // Rimuove il carattere '#' dagli URL su Web
  usePathUrlStrategy();

  runApp(
    ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const OrtoApp(),
    ),
  );
}

class OrtoApp extends StatelessWidget {
  const OrtoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Gestione Orto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6B8E23),
        scaffoldBackgroundColor: const Color(0xFFF4F7F4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8FBC8F),
          surface: const Color(0xFFF4F7F4),
        ),
        useMaterial3: true,
      ),
    );
  }
}
