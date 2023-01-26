import 'package:drop_application/bloc/bid/bid_bloc.dart';
import 'package:drop_application/bloc/item/item_bloc.dart';
import 'package:drop_application/data/repository/firestore_repository.dart';
import 'package:drop_application/data/repository/storage_repository.dart';
import 'package:drop_application/presentation/routing/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'bloc/auction/auction_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/network/network_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'data/repository/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => FirestoreRepository(),
        ),
        RepositoryProvider(
          create: (context) => StorageRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NetworkBloc()..add(NetworkObserveEvent()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of(context),
            ),
          ),
          BlocProvider(
            create: (context) => ItemBloc(
              firestoreRepository: RepositoryProvider.of(context),
              authRepository: RepositoryProvider.of(context),
              storageRepository: RepositoryProvider.of(context),
            ),
          ),
          BlocProvider(
            create: (context) => BidBloc(
              firestoreRepository: RepositoryProvider.of(context),
              authRepository: RepositoryProvider.of(context),
            ),
          ),
          BlocProvider(
            create: (context) => AuctionBloc(
                firestoreRepository: RepositoryProvider.of(context),
                authRepository: RepositoryProvider.of(context),
                storageRepository: RepositoryProvider.of(context)),
          ),
          BlocProvider(
            create: (context) => UserBloc(
              firestoreRepository: RepositoryProvider.of(context),
              authRepository: RepositoryProvider.of(context),
            ),
          ),
        ],
        child: MaterialApp.router(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // delegate from localization package.
            LocalJsonLocalization.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('en', 'GB'),
            Locale('nl', 'BE'),
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.deepPurple),
          routerConfig: router,
        ),
      ),
    );
  }
}
