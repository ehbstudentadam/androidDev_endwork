import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/user/user_bloc.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurpleAccent,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/drawer.jpg'),
              ),
            ),
            child: Text(
              'Account'.i18n(),
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: Text('my-profile'.i18n()),
            onTap: () {
              context.read<UserBloc>().add(LoadUserNameEvent());
              if (GoRouter.of(context).location == '/dashboard' ||
                  GoRouter.of(context).location == '/') {
                GoRouter.of(context).push('/my_profile');
                Navigator.of(context).pop();
              } else {
                GoRouter.of(context).pushReplacement('/my_profile');
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text('logout'.i18n()),
            onTap: () {
              context.read<AuthBloc>().add(SignOutRequestedEvent());
            },
          ),
        ],
      ),
    );
  }
}
