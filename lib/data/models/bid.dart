import 'package:cloud_firestore/cloud_firestore.dart';

class Bid {
  String id;
  final String bidderID;
  final String itemID;
  final double price;
  final DateTime timestamp;

  Bid(
      {this.id = '',
      required this.bidderID,
      required this.itemID,
      required this.price,
      required this.timestamp});

  Map<String, dynamic> toJson() => {
        'id': id,
        'bidderID': bidderID,
        'itemID': itemID,
        'price': price,
        'timestamp': timestamp,
      };

  static Bid fromJson(Map<String, dynamic> json) => Bid(
        id: json['id'],
        bidderID: json['bidderID'],
        itemID: json['itemID'],
        price: json['price'],
        timestamp: (json['timestamp'] as Timestamp).toDate(),
      );
}
