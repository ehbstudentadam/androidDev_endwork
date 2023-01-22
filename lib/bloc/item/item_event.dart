part of 'item_bloc.dart';

@immutable
abstract class ItemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAllItemsEvent extends ItemEvent {}

/*class LoadItemEvent extends ItemEvent {
  final Item item;

  LoadItemEvent(this.item);

  @override
  List<Object> get props => [item];
}*/

class SearchItemByNameEvent extends ItemEvent {
  final String name;

  SearchItemByNameEvent(this.name);

  @override
  List<Object> get props => [name];
}

class SearchItemsFromCurrentUserEvent extends ItemEvent {
  final String name;

  SearchItemsFromCurrentUserEvent(this.name);

  @override
  List<Object> get props => [name];
}

class ChangePageEvent extends ItemEvent {
  final String pageName;

  ChangePageEvent(this.pageName);

  @override
  List<Object> get props => [pageName];
}

class GetAllItemsFromCurrentUserEvent extends ItemEvent {}

class EditItemEvent extends ItemEvent {}

class DeleteItemEvent extends ItemEvent {}
