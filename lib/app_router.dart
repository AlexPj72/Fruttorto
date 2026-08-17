import 'package:go_router/go_router.dart';
import 'package:myapp/views/main_shell.dart';
import 'package:myapp/views/home_dashboard_screen.dart';
import 'package:myapp/views/pianifica_screen.dart';
import 'package:myapp/views/orto_screen.dart';
import 'package:myapp/views/diario_screen.dart';
import 'package:myapp/views/assistente_screen.dart';
import 'package:myapp/views/filosofia_screen.dart';
import 'package:myapp/views/calendario_naturale_screen.dart';
import 'package:myapp/views/appezzamento_detail_screen.dart';
import 'package:myapp/views/login_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeDashboardScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/pianifica', builder: (_, __) => const PianificaScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/orto', builder: (_, __) => const OrtoScreen()),
          GoRoute(path: '/orto/appezzamento/:id',
              builder: (_, s) => AppezzamentoDetailScreen(appezzamentoId: s.pathParameters['id']!)),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/diario', builder: (_, __) => const DiarioScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/assistente', builder: (_, __) => const AssistenteScreen()),
        ]),
      ],
    ),
    GoRoute(path: '/filosofia', builder: (_, __) => const FilosofiaScreen()),
    GoRoute(path: '/calendario-naturale', builder: (_, __) => const CalendarioNaturaleScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
  ],
);
