import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import 'package:myapp/app_router.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/repositories/appezzamento_repository.dart';
import 'package:myapp/providers/garden_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/providers/meteo_provider.dart';
import 'package:myapp/services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await FirebaseAppCheck.instance.activate();
  } catch (e) {
    debugPrint('App Check non attivo: $e');
  }

  try {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) await auth.signInAnonymously();
  } catch (e) {
    debugPrint('Login anonimo fallito: $e');
  }

  usePathUrlStrategy();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => AppezzamentoRepository()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
      ChangeNotifierProvider(create: (_) => MeteoProvider()),
      ChangeNotifierProvider(create: (_) => GardenProvider()),
    ],
    child: const OrtoApp(),
  ));
}

class OrtoApp extends StatelessWidget {
  const OrtoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Fruttorto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
    );
  }
}
