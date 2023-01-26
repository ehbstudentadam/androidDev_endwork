import 'package:drop_application/presentation/authentication/authenticate.dart';
import 'package:drop_application/presentation/authentication/sign_in.dart';
import 'package:drop_application/presentation/authentication/sign_up.dart';
import 'package:drop_application/presentation/pages/auction.dart';
import 'package:drop_application/presentation/pages/my_auctions.dart';
import 'package:drop_application/presentation/pages/my_favourites.dart';
import 'package:drop_application/presentation/pages/new_auction.dart';
import 'package:drop_application/presentation/pages/no_network.dart';
import 'package:drop_application/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/item.dart';

final _parentKey = GlobalKey<NavigatorState>();
//final _shellKey = GlobalKey<NavigatorState>();

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
      builder: (context, state) => const Authenticate(),
    ),
    GoRoute(
      path: '/auction',
      name: 'auction',
      parentNavigatorKey: _parentKey,
      builder: (context, state) {
        Item item = state.extra as Item;
        return Auction(item: item);
      },
    ),
    GoRoute(
      path: '/new_auction',
      name: 'new_auction',
      parentNavigatorKey: _parentKey,
      builder: (context, state) => NewAuction(),
    ),
    GoRoute(
      path: '/my_auctions',
      name: 'my_auctions',
      parentNavigatorKey: _parentKey,
      builder: (context, state) => MyAuctions(),
    ),
    GoRoute(
      path: '/my_favourites',
      name: 'my_favourites',
      parentNavigatorKey: _parentKey,
      builder: (context, state) => MyFavourites(),
    ),
    GoRoute(
      path: '/my_profile',
      name: 'my_profile',
      parentNavigatorKey: _parentKey,
      builder: (context, state) => MyProfile(),
    ),
    GoRoute(
      path: '/no_network',
      name: 'no_network',
      parentNavigatorKey: _parentKey,
      builder: (context, state) => const NoNetwork(),
    ),
    //For Future shellcode
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
