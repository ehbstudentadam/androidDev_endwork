import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/item/item_bloc.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Getting the user from the FirebaseAuth Instance
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnAuthenticated) {
                // Navigate to the sign in screen when the user Signs Out
                GoRouter.of(context).go('/sign_in');
              }
            },
          ),
          BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
              if (state is ItemsLoadingState) {
                context.read<ItemBloc>().add(LoadItemsEvent());
              }
              if (state is ItemErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
        child: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            if (state is ItemsLoadingState) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ItemsLoadedState) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: false,
                    leading: IconButton(
                      onPressed: () {
                        //todo
                      },
                      icon: const Icon(Icons.account_circle),
                    ),
                    title: const Center(
                      child: Text('DROP'),
                    ),
                    actions: [
                      IconButton(
                          icon: const Icon(Icons.home),
                          onPressed: () {
                            //code to execute when this button is pressed
                          }),
                      IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            //code to execute when this button is pressed
                          }),
                    ],
                    bottom: AppBar(
                      title: Container(
                        width: double.infinity,
                        height: 40,
                        color: Colors.white,
                        child: const Center(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Other Sliver Widgets
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Card(
                          margin: const EdgeInsets.all(5),
                          child: Container(
                            color: Colors.purple[100 * (index % 9 + 1)],
                            height: 80,
                            alignment: Alignment.center,
                            child: Text(
                              "Item $index",
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        );
                      },
                      childCount: 1000, // 1000 list items
                    ),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
