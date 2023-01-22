import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/item.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/firestore_repository.dart';
import '../../data/repository/storage_repository.dart';
part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final FirestoreRepository firestoreRepository;
  final AuthRepository authRepository;
  final StorageRepository storageRepository;

  ItemBloc({required this.storageRepository, required this.firestoreRepository, required this.authRepository})
      : super(ItemsLoadingState()) {

    on<LoadAllItemsEvent>((event, emit) async {
      emit(ItemsLoadingState());
      try {
        var items = firestoreRepository.getAllItems();
        emit(ItemsLoadedState(items));
      } catch (e) {
        emit(ItemErrorState(e.toString()));
      }
    });

    on<SearchItemByNameEvent>((event, emit) async {
      emit(ItemsLoadingState());
      try {
        var items = firestoreRepository.searchItemsByName(event.name);
        emit(ItemsLoadedState(items));
      } catch (e) {
        emit(ItemErrorState(e.toString()));
      }
    });

    on<GetAllItemsFromCurrentUserEvent>((event, emit) async {
      emit(ItemsLoadingState());
      try {
        String authUserId =
            await authRepository.getCurrentAuthenticatedUserId();
        String dbUserId = await firestoreRepository.getDBUserIdByAuthUserId(
            authUserId: authUserId);
        var items = firestoreRepository.searchMyItemsByDbUserId(dbUserId);
        emit(MyItemsLoadedState(items));
      } catch (e) {
        emit(ItemErrorState(e.toString()));
      }
    });

    on<SearchItemsFromCurrentUserEvent>((event, emit) async {
      emit(ItemsLoadingState());
      try {
        String authUserId =
        await authRepository.getCurrentAuthenticatedUserId();
        String dbUserId = await firestoreRepository.getDBUserIdByAuthUserId(
            authUserId: authUserId);
        var items = firestoreRepository.searchItemsByDbUserIdAndItemName(dbUserId, event.name);
        emit(ItemsLoadedState(items));
      } catch (e) {
        emit(ItemErrorState(e.toString()));
      }
    });


    on<DeleteItemEvent>((event, emit) async {
      emit(DeletingItemState());
      try {
        String authUserId =
        await authRepository.getCurrentAuthenticatedUserId();
        String dbUserId = await firestoreRepository.getDBUserIdByAuthUserId(
            authUserId: authUserId);

        await firestoreRepository.deleteItem(item: event.item);
        await storageRepository.deleteAllImagesFromItem(itemId: event.item.itemID);

        var items = firestoreRepository.searchMyItemsByDbUserId(dbUserId);
        emit(MyItemsLoadedState(items));
      } catch (e) {
        emit(ItemErrorState(e.toString()));
      }
    });


    add(LoadAllItemsEvent());
  }
}
