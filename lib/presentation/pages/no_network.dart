import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/network/network_bloc.dart';

class NoNetwork extends StatelessWidget {
  const NoNetwork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<NetworkBloc, NetworkState>(
        listener: (context, state) async {
          if (state is NetworkSuccessState) {
            if (GoRouter.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              GoRouter.of(context).pushReplacement('/');
            }
          }
        },
        child: BlocBuilder<NetworkBloc, NetworkState>(
          buildWhen: (previous, current) =>
              previous != current && current is NetworkFailureState,
          builder: (context, state) {
            if (state is NetworkFailureState) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("No network connection..."),
                      Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
