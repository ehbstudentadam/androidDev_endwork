import 'bid.dart';
import 'item.dart';

class DbUser {
  String id;
  final String authUserID;
  final String? userName;
  final List<String>? itemsForSale;
  final List<String>? itemFavourites;
  final List<String>? bids;

  DbUser(
      {this.id = '',
      required this.authUserID,
      this.userName,
      this.itemsForSale,
      this.itemFavourites,
      this.bids});

  Map<String, dynamic> toJson() => {
        'id': id,
        'authUserID': authUserID,
        'userName': userName,
        'itemsForSale': itemsForSale,
        'itemFavourites': itemFavourites,
        'bids': bids,
      };

  static DbUser fromJson(Map<String, dynamic> json) => DbUser(
        id: json['id'],
        authUserID: json['authUserID'],
        userName: json['userName'],
        itemsForSale: json['itemsForSale'] is Iterable
            ? List.from(json['itemsForSale'])
            : null,
        itemFavourites: json['itemFavourites'] is Iterable
            ? List.from(json['itemFavourites'])
            : null,
        bids: json['bids'] is Iterable ? List.from(json['bids']) : null,
      );
}
