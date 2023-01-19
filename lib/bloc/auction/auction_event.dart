part of 'auction_bloc.dart';

@immutable
abstract class AuctionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAuctionEvent extends AuctionEvent {
  final Item item;

  LoadAuctionEvent(this.item);

  @override
  List<Object> get props => [item];
}

class EditAuctionEvent extends AuctionEvent {}

class RemoveAuctionEvent extends AuctionEvent {}
