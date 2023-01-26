import 'dart:async';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:drop_application/data/models/item.dart';
import 'package:drop_application/presentation/widgets/item_panel.dart';
import 'package:drop_application/presentation/widgets/menu_drawer.dart';
import 'package:drop_application/presentation/widgets/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/item/item_bloc.dart';
import '../../bloc/network/network_bloc.dart';

class Dashboard extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _resultNames = [];

  Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      endDrawer: const MenuDrawer(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnAuthenticated) {
                // Navigate to the sign in screen when the user Signs Out
                GoRouter.of(context).pushReplacement('/sign_in');
              }
            },
          ),
          BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
              if (state is ItemErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
              if (state is RefreshPageState) {
                context.read<ItemBloc>().add(LoadAllItemsEvent());
              }
            },
          ),
          BlocListener<NetworkBloc, NetworkState>(
            listener: (context, state) async {
              if (state is NetworkFailureState) {
                GoRouter.of(context).push('/no_network');
                context
                    .read<ItemBloc>()
                    .add(ItemErrorEvent('Network connection lost...'));
              }
            },
          ),
        ],
        child: BlocBuilder<ItemBloc, ItemState>(
          buildWhen: (previous, current) =>
              previous != current && current is ItemsLoadedState,
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
                    shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: false,
                    leading: IconButton(
                      onPressed: () {
                        return Scaffold.of(context).openDrawer();
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
                            if (GoRouter.of(context).location == '/dashboard' ||
                                GoRouter.of(context).location == '/') {
                              if (_resultNames.isEmpty) {
                                context
                                    .read<ItemBloc>()
                                    .add(LoadAllItemsEvent());
                              }
                            }
                          }),
                      IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            return Scaffold.of(context).openEndDrawer();
                          }),
                    ],
                    bottom: AppBar(
                      shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      automaticallyImplyLeading: false,
                      actions: <Widget>[Container()],
                      title: AnimationSearchBar(
                        closeIconColor: Colors.white,
                        isBackButtonVisible: false,
                        centerTitle: 'Dashboard',
                        centerTitleStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20),
                        searchIconColor: Colors.white,
                        onChanged: (value) {},
                        onSubmitted: (value) {
                          context
                              .read<ItemBloc>()
                              .add(SearchAllItemByNameEvent(value));
                        },
                        searchTextEditingController: _searchController,
                        searchFieldDecoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.white.withOpacity(.2), width: .5),
                            borderRadius: BorderRadius.circular(15)),
                        searchBarWidth: MediaQuery.of(context).size.width - 30,
                      ),
                    ),
                  ),
                  StreamBuilder<List<Item>>(
                    stream: state.items,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        throw snapshot.error!;
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          _resultNames.clear();
                          return SliverList(
                            delegate: SliverChildListDelegate([
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child:
                                    Center(child: Text("No auctions found...")),
                              ),
                            ]),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return ItemPanel(item: snapshot.data![index]);
                            },
                            childCount: snapshot.data?.length,
                          ),
                        );
                      } else {
                        Timer(const Duration(seconds: 1), () {
                          context
                              .read<ItemBloc>()
                              .add(LoadAllItemsEvent());
                        });
                        return SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Refreshing..."),
                                  Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        );
                      }
                    },
                  )
                ],
              );
            }
            Timer(const Duration(seconds: 1), () {
              context
                  .read<ItemBloc>()
                  .add(LoadAllItemsEvent());
            });
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Refreshing..."),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
