import 'package:drop_application/bloc/item/item_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auction/auction_bloc.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/drawer.jpg'),
              ),
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sell),
            title: const Text('My Auctions'),
            onTap: () {
              context.read<ItemBloc>().add(GetAllItemsFromCurrentUserEvent());
              if (GoRouter.of(context).location == '/dashboard' ||
                  GoRouter.of(context).location == '/') {
                GoRouter.of(context).push('/my_auctions');
                Navigator.of(context).pop();
              } else {
                GoRouter.of(context).pushReplacement('/my_auctions');
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('New Auction'),
            onTap: () {
              context.read<AuctionBloc>().add(NewAuctionEvent());
              if (GoRouter.of(context).location == '/dashboard' ||
                  GoRouter.of(context).location == '/') {
                GoRouter.of(context).push('/new_auction');
                Navigator.of(context).pop();
              } else {
                GoRouter.of(context).pushReplacement('/new_auction');
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favourites'),
            onTap: () {
              context.read<ItemBloc>().add(GetMyFavouritesEvent());
              if (GoRouter.of(context).location == '/dashboard' ||
                  GoRouter.of(context).location == '/') {
                GoRouter.of(context).push('/my_favourites');
                Navigator.of(context).pop();
              } else {
                GoRouter.of(context).pushReplacement('/my_favourites');
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
