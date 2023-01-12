import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Item {
  //String id;
  final String sellerID;
  final String title;
  final DateTime timestamp;
  final String description;
  final double price;
  final List<String>? images;
  final List<String>? bids;

  Item(
      {//this.id = '',
      required this.sellerID,
      required this.title,
      required this.timestamp,
      required this.description,
      required this.price,
      this.images,
      this.bids});

  Map<String, dynamic> toJson() => {
        //'id': id,
        'sellerID': sellerID,
        'title': title,
        'createdDate': timestamp,
        'description': description,
        'price': price,
        'images': images,
        'bids': bids,
      };

  static Item fromJson(Map<String, dynamic> json) => Item(
        //id: json['id'],
        sellerID: json['sellerID'],
        title: json['title'],
        timestamp: (json['createdDate'] as Timestamp).toDate(),
        description: json['description'],
        price: json['price'],
        images: json?['images'] is Iterable ? List.from(json?['images']) : null,
        bids: json?['bids'] is Iterable ? List.from(json?['bids']) : null,
      );
}
