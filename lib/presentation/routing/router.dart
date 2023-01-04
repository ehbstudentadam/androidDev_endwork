import 'package:drop_application/presentation/routing/skeleton.dart';
import 'package:go_router/go_router.dart';
import '../pages/authentication/widget_auth_tree.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
        builder: (context, state, child) => Skeleton(widget: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const WidgetAuthTree(),
          ),
          /*GoRoute(
            path: '/2',
            builder: (context, state) => const SecondPage(),
          )*/
        ])
  ],
);