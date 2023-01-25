part of 'bid_bloc.dart';

@immutable
abstract class BidEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAllBidsEvent extends BidEvent {
  final Item item;

  LoadAllBidsEvent(this.item);

  @override
  List<Object> get props => [item];
}

class CreateBidEvent extends BidEvent {
  final Item item;
  final double price;

  CreateBidEvent(this.item, this.price);

  @override
  List<Object> get props => [item, price];
}

class DeleteBidEvent extends BidEvent {
  //todo
}
