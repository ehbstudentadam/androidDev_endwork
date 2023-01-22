import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_application/data/models/bid.dart';
import 'package:drop_application/data/models/db_user.dart';
import '../models/item.dart';

class FirestoreRepository {
  final _firestoreDB = FirebaseFirestore.instance;

  Future<void> createDBUser({
    required String authUserID,
  }) async {
    try {
      final docUser = _firestoreDB.collection('users').doc();
      final dbUser = DbUser(authUserID: authUserID, userName: 'new user');
      final json = dbUser.toJson();

      await docUser.set(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> createBid({
    required String bidderID,
    required String itemID,
    required double price,
  }) async {
    try {
      //add bid
      final docBids = _firestoreDB.collection('bids').doc();
      final bid = Bid(
          bidderID: bidderID,
          itemID: itemID,
          price: price,
          timestamp: DateTime.now());
      final json = bid.toJson();

      await docBids.set(json);
      String bidId = docBids.id;

      //update item with new bid
      final docItem = _firestoreDB.collection('items').doc(itemID);
      docItem.update({
        'bids': FieldValue.arrayUnion([bidId].toList()),
      });

      //update user with new bid
      final docDbUser = _firestoreDB.collection('users').doc(bidderID);
      docDbUser.update({
        'bids': FieldValue.arrayUnion([bidId].toList()),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> createItem({required Item item}) async {
    try {
      final docItem = _firestoreDB.collection('items').doc();
      final json = item.toJson();
      await docItem.set(json);

      String itemIdJustCreated = docItem.id;

      final docUser = _firestoreDB.collection('users').doc(item.sellerID);
      docUser.update({
        'itemsForSale': FieldValue.arrayUnion([itemIdJustCreated].toList()),
      });

      return itemIdJustCreated;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteItem({required Item item}) async {
    try {
      final docItem = _firestoreDB.collection('items').doc(item.itemID);

      await docItem.delete().whenComplete(() async {
        //Delete linked bids
        if (item.bids != null) {
          for (var bidId in item.bids!) {
            final docBid = _firestoreDB.collection('bids').doc(bidId);
          }
        }

        //Delete link with dbUser
        final docUser = _firestoreDB
            .collection('users')
            .where('bids', arrayContains: item.itemID);
        final snapshot = await docUser.get();

        // Iterate through the documents in the snapshot
        for (var doc in snapshot.docs) {
          if (doc.exists) {
            doc.reference.update({
              'bids': FieldValue.arrayRemove([item.itemID].toList())
            });
          }
        }
      });

    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> linkImageToItem(
      {required String itemID, required String imageDownloadLink}) async {
    try {
      final docItem = _firestoreDB.collection('items').doc(itemID);
      docItem.update({
        'images': FieldValue.arrayUnion([imageDownloadLink].toList()),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getDbUserNameFromDbUserID({required String dbUserID}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserID);
      final snapshot = await docUser.get();

      if (snapshot.exists) {
        if (snapshot.data() != null) {
          return DbUser.fromJson(snapshot.data()!).userName;
        }
      }
      throw Exception("getDBUserByDBUserId() No fireStore userName found");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<DbUser> getDBUserByDBUserId({required String dbUserID}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserID);
      final snapshot = await docUser.get();

      if (snapshot.exists) {
        return DbUser.fromJson(snapshot.data()!);
      }
      throw Exception("getDBUserByDBUserId() No fireStore user found");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getDBUserIdByAuthUserId({required String authUserId}) async {
    try {
      final docUser = _firestoreDB
          .collection('users')
          .where('authUserID', isEqualTo: authUserId);
      final snapshot = await docUser.get();

      // Iterate through the documents in the snapshot
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          return doc.id;
        }
      }
      throw Exception("getDBUserIdByAuthUserId() No fireStore user found");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Bid?> getBidByBidId({required String bidID}) async {
    final docBid = _firestoreDB.collection('bids').doc(bidID);
    final snapshot = await docBid.get();

    if (snapshot.exists) {
      return Bid.fromJson(snapshot.data()!);
    }

    return null;
  }

  Future<DbUser?> getBidderDBUserByBidId({required String bidID}) async {
    final docUser =
        _firestoreDB.collection('bids').where('bidderID', isEqualTo: bidID);
    final snapshot = await docUser.get();

    // Iterate through the documents in the snapshot
    for (var doc in snapshot.docs) {
      if (doc.exists) {
        return DbUser.fromJson(doc.data());
      }
    }
    return null;
  }

  Future<DbUser?> getSellerDBUserByItemId({required String itemID}) async {
    final docUser =
        _firestoreDB.collection('bids').where('sellerID', isEqualTo: itemID);
    final snapshot = await docUser.get();

    // Iterate through the documents in the snapshot
    for (var doc in snapshot.docs) {
      if (doc.exists) {
        return DbUser.fromJson(doc.data());
      }
    }
    return null;
  }

  Future<Item?> getItemByItemId({required String itemID}) async {
    final docItem = _firestoreDB.collection('items').doc(itemID);
    final snapshot = await docItem.get();

    // Iterate through the documents in the snapshot
    if (snapshot.exists) {
      return Item.fromJson(snapshot.data()!);
    }
    return null;
  }

  Stream<List<Bid>> getAllBidsByDBUserId(
          {required String dbUserID}) =>
      _firestoreDB
          .collection('bids')
          .where('bidderID', isEqualTo: dbUserID)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Bid.fromJson(doc.data())).toList());

  Stream<List<Item>> getAllItemsByDBUserId({required String dbUserID}) =>
      _firestoreDB
          .collection('items')
          .where('sellerID', isEqualTo: dbUserID)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());

  Stream<List<Bid>> getAllBidsByItemId({required String itemID}) async* {
    try {
      yield* _firestoreDB
          .collection('bids')
          .where('itemID', isEqualTo: itemID)
          .snapshots()
          .asyncMap<List<Bid>>((event) async {
        List<Bid> bids = [];

        for (var doc in event.docs) {
          try {
            Bid bid = Bid.fromJson(doc.data());
            bid.bidId = doc.id;
            bid.userName =
                await getDbUserNameFromDbUserID(dbUserID: bid.bidderID);

            bids.add(bid);
          } catch (e) {
            throw Exception(e);
          }
        }
        return bids;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Item>> getAllItems() {
    try {
      return _firestoreDB
          .collection('items')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                Item item = Item.fromJson(doc.data());
                item.itemID = doc.id;
                return item;
              }).toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Item>> searchItemsByName(String search) {
    try {
      return _firestoreDB
          .collection('items')
          .where('title', isEqualTo: search)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                Item item = Item.fromJson(doc.data());
                item.itemID = doc.id;
                return item;
              }).toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Item>> searchMyItemsByDbUserId(String dbUserId) {
    try {
      return _firestoreDB
          .collection('items')
          .where('sellerID', isEqualTo: dbUserId)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                Item item = Item.fromJson(doc.data());
                item.itemID = doc.id;
                item.isMyItem = true;
                return item;
              }).toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Item>> searchItemsByDbUserIdAndItemName(
      String dbUserId, String search) {
    try {
      return _firestoreDB
          .collection('items')
          .where('sellerID', isEqualTo: dbUserId)
          .where('title', isEqualTo: search)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                Item item = Item.fromJson(doc.data());
                item.itemID = doc.id;
                return item;
              }).toList());
    } catch (e) {
      throw Exception(e);
    }
  }
}
