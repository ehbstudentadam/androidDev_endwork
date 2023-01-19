import 'package:drop_application/data/models/bid.dart';
import 'package:drop_application/data/models/item.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/firestore_repository.dart';
part 'bid_event.dart';
part 'bid_state.dart';

class BidBloc extends Bloc<BidEvent, BidState> {
  final FirestoreRepository firestoreRepository;
  final AuthRepository authRepository;

  BidBloc({required this.authRepository, required this.firestoreRepository})
      : super(BidsLoadingState()) {
    on<LoadAllBidsEvent>(
      (event, emit) async {
        emit(BidsLoadingState());
        try {
          Item item = event.item!;
          var bids =
              firestoreRepository.getAllBidsByItemId(itemID: item.itemID);
          emit(BidsLoadedState(bids));
        } catch (e) {
          emit(BidErrorState(e.toString()));
        }
      },
    );

    on<CreateBidEvent>((event, emit) async {
      try {
        String authUserId =
            await authRepository.getCurrentAuthenticatedUserId();
        String dbUser = await firestoreRepository.getDBUserIdByAuthUserId(
            authUserId: authUserId);

        await firestoreRepository.createBid(
            bidderID: dbUser, itemID: event.item.itemID, price: event.price);

        add(LoadAllBidsEvent(event.item));
      } catch (e) {
        emit(BidErrorState(e.toString()));
      }
    });
  }
}
