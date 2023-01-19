part of 'bid_bloc.dart';

@immutable
abstract class BidState extends Equatable {}

class BidsInitialState extends BidState {
  @override
  List<Object?> get props => [];
}

class BidsLoadingState extends BidState {
  @override
  List<Object?> get props => [];
}

class BidsLoadedState extends BidState {
  final Stream<List<Bid>> bids;

  BidsLoadedState(this.bids);

  @override
  List<Object?> get props => [bids];
}

class BidErrorState extends BidState {
  final String error;

  BidErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
