import 'package:cloud_firestore/cloud_firestore.dart';

class Bid {
  late String bidId;
  late String userName;
  final String bidderID;
  final String itemID;
  final double price;
  final DateTime timestamp;


  Bid(
      {
      required this.bidderID,
      required this.itemID,
      required this.price,
      required this.timestamp});

  Map<String, dynamic> toJson() => {
        'bidderID': bidderID,
        'itemID': itemID,
        'price': price,
        'timestamp': timestamp,
      };

  static Bid fromJson(Map<String, dynamic> json) => Bid(
        bidderID: json['bidderID'],
        itemID: json['itemID'],
        price: json['price'],
        timestamp: (json['timestamp'] as Timestamp).toDate(),
      );
}
