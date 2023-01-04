import 'package:firebase_auth/firebase_auth.dart';
import 'bid.dart';
import 'item.dart';

class DbUser{

  String id;
  final User authUser;
  late List<Item> itemsForSale;
  late List<Item> itemFavourites;
  late List<Bid> bids;

  DbUser(this.id, this.authUser);
}