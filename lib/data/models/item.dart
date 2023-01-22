import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  late String itemID;
  final String sellerID;
  final String title;
  final DateTime timestamp;
  final String description;
  final double price;
  final List<String>? images;
  final List<String>? bids;
  bool toDelete = false;
  bool isMyItem = false;

  Item(
      {required this.sellerID,
      required this.title,
      required this.timestamp,
      required this.description,
      required this.price,
      this.images,
      this.bids});

  Map<String, dynamic> toJson() => {
        'sellerID': sellerID,
        'title': title,
        'createdDate': timestamp,
        'description': description,
        'price': price,
        if (images != null) 'images': images,
        if (bids != null) 'bids': bids,
      };

  static Item fromJson(Map<String, dynamic> json) => Item(
        sellerID: json['sellerID'],
        title: json['title'],
        timestamp: (json['createdDate'] as Timestamp).toDate(),
        description: json['description'],
        price: json['price'],
        images: json?['images'] is Iterable ? List.from(json?['images']) : null,
        bids: json?['bids'] is Iterable ? List.from(json?['bids']) : null,
      );
}
