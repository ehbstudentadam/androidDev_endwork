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

class OpenNewAuctionPageEvent extends AuctionEvent {
  @override
  List<Object> get props => [];
}

class PostNewAuctionEvent extends AuctionEvent {
  final String auctionName;
  final double auctionPrice;
  final String auctionDescription;
  final List<PlatformFile> filePickerResults;

  PostNewAuctionEvent(this.auctionName, this.auctionPrice,
      this.auctionDescription, this.filePickerResults);

  @override
  List<Object> get props => [auctionName, auctionPrice, auctionDescription];
}

class EditAuctionEvent extends AuctionEvent {
  //todo
}