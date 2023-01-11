import 'package:drop_application/presentation/authentication/authenticate.dart';
import 'package:drop_application/presentation/authentication/sign_in.dart';
import 'package:drop_application/presentation/authentication/sign_up.dart';
import 'package:drop_application/presentation/pages/dashboard.dart';
import 'package:drop_application/presentation/routing/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _parentKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: _parentKey,
  routes: [
    GoRoute(
      path: '/',
      parentNavigatorKey: _parentKey,
      builder: (context, state) => const Authenticate(),
    ),
    GoRoute(
      path: '/sign_up',
      parentNavigatorKey: _parentKey,
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      path: '/sign_in',
      parentNavigatorKey: _parentKey,
      builder: (context, state) => const SignIn(),
    ),
    GoRoute(
      path: '/dashboard',
      parentNavigatorKey: _parentKey,
      builder: (context, state) => const Dashboard(),
    ),
    /*ShellRoute(
      navigatorKey: _shellKey,
      builder: (context, state, child) => Skeleton(widget: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          parentNavigatorKey: _shellKey,
          builder: (context, state) => const Dashboard(),
        ),
      ],
    ),*/
  ],
);
