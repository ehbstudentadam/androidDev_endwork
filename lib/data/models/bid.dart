import 'db_user.dart';

class Bid{
  String id;
  final DbUser bidder;
  final double price;

  Bid(this.id, this.bidder, this.price);

}