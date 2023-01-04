import 'dart:collection';
import 'package:drop_application/data/models/bid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'db_user.dart';

class Item{
  String id;
  String title;
  final DbUser seller;
  final DateTime createdDate;
  String description;
  double price;
  late List<Reference> images;
  late HashMap<DbUser, Bid> bids;

  Item(this.id, this.title, this.seller, this.createdDate, this.price, this.description);
}