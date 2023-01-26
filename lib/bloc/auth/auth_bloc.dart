import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnAuthenticatedState()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequestedEvent>((event, emit) async {
      emit(LoadingState());
      try {
        await authRepository.signIn(
            email: event.email, password: event.password);
        emit(AuthenticatedState());
      } catch (e) {
        emit(AuthErrorState(e.toString()));
        emit(UnAuthenticatedState());
      }
    });

    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignUpRequestedEvent>((event, emit) async {
      emit(LoadingState());
      try {
        await authRepository.signUp(
            email: event.email, password: event.password);
        emit(AuthenticatedState());
      } catch (e) {
        emit(AuthErrorState(e.toString()));
        emit(UnAuthenticatedState());
      }
    });

    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequestedEvent>((event, emit) async {
      emit(LoadingState());
      await authRepository.signOut();
      emit(UnAuthenticatedState());
    });
  }
}
