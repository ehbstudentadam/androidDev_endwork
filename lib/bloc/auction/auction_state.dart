part of 'auction_bloc.dart';

@immutable
abstract class AuctionState extends Equatable {}

class AuctionInitial extends AuctionState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuctionLoadingState extends AuctionState {
  @override
  List<Object?> get props => [];
}

class AuctionLoadedState extends AuctionState {
  final Item item;
  final DbUser dbUser;

  AuctionLoadedState(this.item, this.dbUser);

  @override
  List<Object?> get props => [item];
}

class AuctionErrorState extends AuctionState {
  final String error;

  AuctionErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
