import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/db_user.dart';
import '../../data/models/item.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/firestore_repository.dart';
import '../../data/repository/storage_repository.dart';
part 'auction_event.dart';
part 'auction_state.dart';

class AuctionBloc extends Bloc<AuctionEvent, AuctionState> {
  final FirestoreRepository firestoreRepository;
  final AuthRepository authRepository;
  final StorageRepository storageRepository;

  AuctionBloc(
      {required this.storageRepository,
      required this.authRepository,
      required this.firestoreRepository})
      : super(AuctionLoadingState()) {
    on<LoadAuctionEvent>((event, emit) async {
      emit(AuctionLoadingState());
      try {
        DbUser? databaseUser = await firestoreRepository.getDBUserByDBUserId(
            dbUserID: event.item.sellerID);
        emit(AuctionLoadedState(event.item, databaseUser));
      } catch (e) {
        emit(AuctionErrorState(e.toString()));
      }
    });

    on<NewAuctionEvent>((event, emit) async {
      emit(NewAuctionLoadingState());
      try {
        emit(NewAuctionLoadedState());
      } catch (e) {
        emit(AuctionErrorState(e.toString()));
      }
    });

    on<PostNewAuctionEvent>((event, emit) async {
      emit(PostNewAuctionLoadingState());
      try {
        String authUserId =
            await authRepository.getCurrentAuthenticatedUserId();
        String dbUserId = await firestoreRepository.getDBUserIdByAuthUserId(
            authUserId: authUserId);

        Item item = Item(
            sellerID: dbUserId,
            title: event.auctionName,
            timestamp: DateTime.now(),
            description: event.auctionDescription,
            price: event.auctionPrice);

        String itemIdJustCreated =
            await firestoreRepository.createItem(item: item);

        if (event.filePickerResults.isNotEmpty) {
          await storageRepository.uploadImage(
              itemID: itemIdJustCreated,
              filePickerResult: event.filePickerResults);
        }

        emit(PostNewAuctionLoadedState());
      } catch (e) {
        emit(AuctionErrorState(e.toString()));
      }
    });
  }
}
