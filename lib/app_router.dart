import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/appezzamento.dart';
import 'package:myapp/screens/orto_screen.dart';
import 'package:myapp/views/appezzamento_detail_screen.dart';
import 'package:myapp/views/home_screen.dart';
import 'package:myapp/views/login_screen.dart';

// Definiamo la chiave globale per il navigatore
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey, // Colleghiamo la chiave al router
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <GoRoute>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            final appezzamento = state.extra as Appezzamento;
            return AppezzamentoDetailScreen(appezzamento: appezzamento);
          },
        ),
        GoRoute(
          path: 'orto',
          builder: (BuildContext context, GoRouterState state) {
            return const OrtoScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
  ],
);
