import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:myapp/app_router.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';
import 'package:myapp/providers/garden_provider.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

  usePathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AppezzamentoRepository()),
        ChangeNotifierProvider(create: (_) => GardenProvider()),
      ],
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
