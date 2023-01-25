import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/auth_repository.dart';
import '../../data/repository/firestore_repository.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreRepository firestoreRepository;
  final AuthRepository authRepository;

  UserBloc({required this.firestoreRepository, required this.authRepository})
      : super(UserInitialState()) {

    on<LoadUserNameEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        String authUserId =
        await authRepository.getCurrentAuthenticatedUserId();
        String dbUserId = await firestoreRepository.getDBUserIdByAuthUserId(
            authUserId: authUserId);
        var userName = await firestoreRepository.getDbUserNameFromDbUserID(dbUserID: dbUserId);
        emit(UserLoadedState(userName));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });



    on<UpdateUserNameEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        String authUserId =
            await authRepository.getCurrentAuthenticatedUserId();
        String dbUserId = await firestoreRepository.getDBUserIdByAuthUserId(
            authUserId: authUserId);
        await firestoreRepository.updateDbUserNameFromDbUserID(dbUserID: dbUserId, newUserName: event.userName);
        var userName = await firestoreRepository.getDbUserNameFromDbUserID(dbUserID: dbUserId);
        emit(UserLoadedState(userName));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }
}
