import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/screens/orto_screen.dart';
import 'package:myapp/views/appezzamento_detail_screen.dart';
import 'package:myapp/views/home_screen.dart';
import 'package:myapp/views/login_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <GoRoute>[
        GoRoute(
          path: 'details/:id',
          builder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id']!;
            return AppezzamentoDetailScreen(appezzamentoId: id);
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
