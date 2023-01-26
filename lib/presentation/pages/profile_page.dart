import 'package:drop_application/presentation/widgets/menu_drawer.dart';
import 'package:drop_application/presentation/widgets/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/item/item_bloc.dart';
import '../../bloc/network/network_bloc.dart';
import '../../bloc/user/user_bloc.dart';

class MyProfile extends StatelessWidget {
  MyProfile({Key? key}) : super(key: key);

  final _formKeyProfile = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<String> _resultNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      endDrawer: const MenuDrawer(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnAuthenticatedState) {
                // Navigate to the sign in screen when the user Signs Out
                GoRouter.of(context).go('/sign_in');
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<NetworkBloc, NetworkState>(
            listener: (context, state) async {
              if (state is NetworkFailureState) {
                GoRouter.of(context).push('/no_network');
              }
            },
          ),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
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
                  title: Center(
                    child: Text('DROP'.i18n()),
                  ),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.home),
                        onPressed: () {
                          if (GoRouter.of(context).location == '/dashboard' ||
                              GoRouter.of(context).location == '/') {
                            if (_resultNames.isEmpty) {
                              context.read<ItemBloc>().add(LoadAllItemsEvent());
                            }
                          }
                          if (GoRouter.of(context).location == '/my_profile') {
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
                    title: Center(
                      child: Text("Profile-configuration".i18n(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
                // Other Sliver Widgets
                SliverLayoutBuilder(
                  builder: (context, constraints) {
                    if (state is UserLoadingState) {
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
                    if (state is UserLoadedState) {
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          Form(
                            key: _formKeyProfile,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Text(
                                    "Current-username:".i18n([state.userName]),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24.0, right: 24),
                                  child: Text(
                                    'Enter-new-username:'.i18n(),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: TextFormField(
                                      textAlignVertical: TextAlignVertical.top,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.text,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        return value!.length > 3 &&
                                            value.length < 20
                                            ? null
                                            : "Username-between-3-20-characters".i18n();
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.update,
                                        color: Colors.white,
                                      ),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            side: const BorderSide(
                                                color: Colors.deepPurple),
                                          ),
                                        ),
                                      ),
                                      label: Text(
                                        'Update-name'.i18n(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onPressed: () {
                                        if (_formKeyProfile.currentState!
                                            .validate()) {
                                          context.read<UserBloc>().add(
                                              UpdateUserNameEvent(
                                                  _nameController.text));
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                      );
                    }
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
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
