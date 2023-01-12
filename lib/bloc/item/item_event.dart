part of 'item_bloc.dart';

@immutable
abstract class ItemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadItemsEvent extends ItemEvent{
}

class CreateItemEvent extends ItemEvent {
  final String title;
  final DateTime timestamp;
  final String description;
  final double price;
  final List<String>? images;

  CreateItemEvent(
      this.title, this.timestamp, this.description, this.price, this.images);
}

class EditItemEvent extends ItemEvent {}

class DeleteItemEvent extends ItemEvent {}
