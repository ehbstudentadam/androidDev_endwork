part of 'item_bloc.dart';

@immutable
abstract class ItemState extends Equatable {}

class ItemsLoadingState extends ItemState {
  @override
  List<Object?> get props => [];
}

class RefreshPageState extends ItemState {
  @override
  List<Object?> get props => [];
}

class ItemsLoadedState extends ItemState {
  final Stream<List<Item>> items;

  ItemsLoadedState(this.items);

  @override
  List<Object?> get props => [items];
}

class MyItemsLoadedState extends ItemState {
  final Stream<List<Item>> items;

  MyItemsLoadedState(this.items);

  @override
  List<Object?> get props => [items];
}

class MyFavouritesLoadedState extends ItemState {
  final List<Item>? items;

  MyFavouritesLoadedState(this.items);

  @override
  List<Object?> get props => [items];
}


class DeletingItemState extends ItemState {
  @override
  List<Object?> get props => [];
}

class ItemErrorState extends ItemState {
  final String error;

  ItemErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
