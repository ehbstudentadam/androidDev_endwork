import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/item.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/firestore_repository.dart';
part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final FirestoreRepository firestoreRepository;
  final AuthRepository authRepository;

  ItemBloc({required this.firestoreRepository, required this.authRepository})
      : super(ItemsLoadingState()) {

    on<CreateItemEvent>((event, emit) async {
      emit(ItemsLoadingState());
      try {
        await firestoreRepository.createItem(
            authUserID: await authRepository.getCurrentAuthenticatedUserId(),
            title: event.title,
            description: event.description,
            price: event.price);
        var items = firestoreRepository.getAllItems();
        emit(ItemsLoadedState(items));
      } catch (e) {
        emit(ItemErrorState(e.toString()));
      }
    });

    on<LoadItemsEvent>((event, emit) async {
      emit(ItemsLoadingState());
      var items = firestoreRepository.getAllItems();
      emit(ItemsLoadedState(items));
    });

  }
}
