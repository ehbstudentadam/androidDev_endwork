part of 'bid_bloc.dart';

@immutable
abstract class BidEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CreateBidEvent extends BidEvent{
  final Item item;
  final double price;

  CreateBidEvent(this.item, this.price);
}

class LoadAllBidsEvent extends BidEvent {
  final Item? item;

  LoadAllBidsEvent(this.item);
}

class DeleteBidEvent extends BidEvent{}

