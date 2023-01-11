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

class ItemErrorState extends ItemState{
  final String error;

  ItemErrorState(this.error);
  @override
  List<Object?> get props => [error];
}