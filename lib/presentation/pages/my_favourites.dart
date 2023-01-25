import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:drop_application/presentation/widgets/item_panel.dart';
import 'package:drop_application/presentation/widgets/menu_drawer.dart';
import 'package:drop_application/presentation/widgets/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/item/item_bloc.dart';

class MyFavourites extends StatelessWidget {
  final _searchController = TextEditingController();
  final List<String> _resultNames = [];

  MyFavourites({Key? key}) : super(key: key);

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
                GoRouter.of(context).go('/sign_in');
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
                context.read<ItemBloc>().add(GetMyFavouritesEvent());
              }
            },
          ),
        ],
        child: BlocBuilder<ItemBloc, ItemState>(
          buildWhen: (previous, current) =>
              previous != current && current is MyFavouritesLoadedState,
          builder: (context, state) {
            if (state is ItemsLoadingState) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is MyFavouritesLoadedState) {
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
                            if (GoRouter.of(context).location ==
                                '/my_favourites') {
                              context.read<ItemBloc>().add(LoadAllItemsEvent());
                              GoRouter.of(context).go('/');
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
                        centerTitle: 'My Favourites',
                        centerTitleStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20),
                        searchIconColor: Colors.white,
                        onChanged: (value) {},
                        onSubmitted: (value) {
                          context
                              .read<ItemBloc>()
                              .add(SearchItemsFromCurrentUserEvent(value));
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
                  // Other Sliver Widgets
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (state.items == null || state.items!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                                child: Text("No auctions found...")),
                          );
                        } else {
                          return ItemPanel(item: state.items![index]);
                        }
                      },
                      childCount: state.items?.length ?? 1,
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
