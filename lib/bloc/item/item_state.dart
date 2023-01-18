part of 'item_bloc.dart';

@immutable
abstract class ItemState extends Equatable {}

class ItemsLoadingState extends ItemState {
  @override
  List<Object?> get props => [];
}

class ItemsLoadedState extends ItemState {
  final Stream<List<Item>> items;

  ItemsLoadedState(this.items);

  @override
  List<Object?> get props => [items];
}

class ItemLoadingState extends ItemState {
  @override
  List<Object?> get props => [];
}

class ItemLoadedState extends ItemState {
  final Item item;
  final DbUser dbUser;

  ItemLoadedState(this.item, this.dbUser);

  @override
  List<Object?> get props => [item];
}

class ItemErrorState extends ItemState {
  final String error;

  ItemErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
