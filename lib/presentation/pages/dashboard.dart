import 'package:drop_application/data/models/item.dart';
import 'package:drop_application/presentation/widgets/item_panel.dart';
import 'package:drop_application/presentation/widgets/menu_drawer.dart';
import 'package:drop_application/presentation/widgets/user_drawer.dart';
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
                              //do nothing
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
                      title: Container(
                        width: double.infinity,
                        height: 40,
                        //color: Colors.white,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                              ),
                              hintText: '    Search...',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Other Sliver Widgets
                  StreamBuilder<List<Item>>(
                      stream: state.items,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // todo
                        }
                        if (snapshot.hasData) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ItemPanel(item: snapshot.data![index]);
                              },
                              childCount: snapshot.data?.length,
                            ),
                          );
                        } else {
                          return SliverList(
                            delegate: SliverChildListDelegate([
                              const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ]),
                          );
                        }
                      })
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
