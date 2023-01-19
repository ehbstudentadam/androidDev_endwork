import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/db_user.dart';
import '../../data/models/item.dart';
import '../../data/repository/firestore_repository.dart';
part 'auction_event.dart';
part 'auction_state.dart';

class AuctionBloc extends Bloc<AuctionEvent, AuctionState> {
  final FirestoreRepository firestoreRepository;

  AuctionBloc({required this.firestoreRepository})
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
  }
}
