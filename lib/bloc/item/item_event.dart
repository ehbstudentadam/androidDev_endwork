part of 'item_bloc.dart';

@immutable
abstract class ItemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAllItemsEvent extends ItemEvent {}

class SearchAllItemByNameEvent extends ItemEvent {
  final String name;

  SearchAllItemByNameEvent(this.name);

  @override
  List<Object> get props => [name];
}

class GetAllItemsFromCurrentUserEvent extends ItemEvent {}

class SearchItemsFromCurrentUserEvent extends ItemEvent {
  final String name;

  SearchItemsFromCurrentUserEvent(this.name);

  @override
  List<Object> get props => [name];
}

class GetMyFavouritesEvent extends ItemEvent {}

class SearchFavouritesEvent extends ItemEvent {
  final String name;

  SearchFavouritesEvent(this.name);

  @override
  List<Object> get props => [name];
}

class AddAsFavouriteEvent extends ItemEvent {
  final String itemId;

  AddAsFavouriteEvent(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class RemoveAsFavouriteEvent extends ItemEvent {
  final String itemId;

  RemoveAsFavouriteEvent(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class DeleteItemEvent extends ItemEvent {
  final Item item;

  DeleteItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

class ItemErrorEvent extends ItemEvent {
  final String error;

  ItemErrorEvent(this.error);
  @override
  List<Object> get props => [error];
}

class EditItemEvent extends ItemEvent {
  //todo
}
