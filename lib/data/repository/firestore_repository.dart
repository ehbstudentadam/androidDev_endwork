import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_application/data/models/bid.dart';
import 'package:drop_application/data/models/db_user.dart';
import '../models/item.dart';

class FirestoreRepository {
  final _firestoreDB = FirebaseFirestore.instance;

  //Used for linking firebase-authentication user to firestore-database user
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
      //create new bid to database
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
      //create new item in database
      final docItem = _firestoreDB.collection('items').doc();
      final json = item.toJson();
      await docItem.set(json);

      //update database user with new item
      String itemIdJustCreated = docItem.id;

      final docUser = _firestoreDB.collection('users').doc(item.sellerID);
      docUser.update({
        'itemsForSale': FieldValue.arrayUnion([itemIdJustCreated].toList()),
      });

      //returning new itemId for later linking with storage images
      return itemIdJustCreated;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteItem({required Item item}) async {
    try {
      //Delete item
      final docItem = _firestoreDB.collection('items').doc(item.itemID);
      await docItem.delete().whenComplete(
        () async {
          //Delete linked bids
          if (item.bids != null) {
            for (var bidId in item.bids!) {
              final docBid = _firestoreDB.collection('bids').doc(bidId);
              await docBid.delete().whenComplete(() async {
                //Delete bidId from dbUser
                final docUser = _firestoreDB
                    .collection('users')
                    .where('bids', arrayContains: bidId);
                final snapshot = await docUser.get();
                // Iterate through the documents in the snapshot
                for (var doc in snapshot.docs) {
                  if (doc.exists) {
                    doc.reference.update({
                      'bids': FieldValue.arrayRemove([bidId].toList())
                    });
                  }
                }
              });
            }
          }
          //Delete itemId from dbUser
          final docUser = _firestoreDB
              .collection('users')
              .where('itemsForSale', arrayContains: item.itemID);
          final snapshot = await docUser.get();
          // Iterate through the documents in the snapshot
          for (var doc in snapshot.docs) {
            if (doc.exists) {
              doc.reference.update({
                'itemsForSale': FieldValue.arrayRemove([item.itemID].toList())
              });
            }
          }
          //Delete from favourites if present
          final docUserF = _firestoreDB
              .collection('users')
              .where('itemFavourites', arrayContains: item.itemID);
          final snapshotF = await docUserF.get();
          // Iterate through the documents in the snapshot
          for (var doc in snapshotF.docs) {
            if (doc.exists) {
              doc.reference.update({
                'itemFavourites': FieldValue.arrayRemove([item.itemID].toList())
              });
            }
          }
        },
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  //used to link download link of image to item
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

  Future<void> addItemToMyFavourites(
      {required String itemId, required String dbUserId}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserId);
      docUser.update({
        'itemFavourites': FieldValue.arrayUnion([itemId].toList()),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeItemFromMyFavourites(
      {required String itemId, required String dbUserId}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserId);
      docUser.update({
        'itemFavourites': FieldValue.arrayRemove([itemId].toList())
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getDbUserNameFromDbUserId({required String dbUserID}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserID);
      final snapshot = await docUser.get();

      if (snapshot.exists) {
        if (snapshot.data() != null) {
          return DbUser.fromJson(snapshot.data()!).userName;
        }
      }
      throw Exception(
          "getDbUserNameFromDbUserId() No fireStore userName found");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateDbUserNameFromDbUserId(
      {required String dbUserID, required String newUserName}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserID);
      docUser.update({
        'userName': newUserName,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<DbUser> getDbUserByDbUserId({required String dbUserID}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserID);
      final snapshot = await docUser.get();

      if (snapshot.exists) {
        return DbUser.fromJson(snapshot.data()!);
      }
      throw Exception("getDbUserByDbUserId() No fireStore user found");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getDbUserIdByAuthUserId({required String authUserId}) async {
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
      throw Exception("getDbUserIdByAuthUserId() No fireStore user found");
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Bid>> getAllBidsByItemId({required String itemID}) async* {
    try {
      yield* _firestoreDB
          .collection('bids')
          .where('itemID', isEqualTo: itemID)
          .snapshots()
          .asyncMap<List<Bid>>((event) async {
        List<Bid> bids = [];

        //for each bid, do lookup for username and add assign to bid
        for (var doc in event.docs) {
          try {
            Bid bid = Bid.fromJson(doc.data());
            bid.bidId = doc.id;
            bid.userName =
                await getDbUserNameFromDbUserId(dbUserID: bid.bidderID);
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

  Future<bool> checkIfItemIdIsFavourite(
      {required String itemId, required String dbUserId}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserId);
      final snapshot = await docUser.get();

      if (snapshot.exists) {
        if (snapshot.data() != null) {
          if (DbUser.fromJson(snapshot.data()!).itemFavourites != null) {
            if (DbUser.fromJson(snapshot.data()!).itemFavourites!.isNotEmpty) {
              if (DbUser.fromJson(snapshot.data()!)
                  .itemFavourites!
                  .contains(itemId)) {
                return true;
              }
            }
          }
        }
      }
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Item>> getAllItems({required String currentDbUser}) async* {
    try {
      yield* _firestoreDB
          .collection('items')
          .snapshots()
          .asyncMap<List<Item>>((event) async {
        List<Item> items = [];

        //for each item, do lookup if item is personal favourite and assign to item
        for (var doc in event.docs) {
          try {
            Item item = Item.fromJson(doc.data());
            item.itemID = doc.id;
            item.isMyFavourite = await checkIfItemIdIsFavourite(
                itemId: doc.id, dbUserId: currentDbUser);

            items.add(item);
          } catch (e) {
            throw Exception(e);
          }
        }
        return items;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Item>> searchItemsByName(
      {required String currentDbUser, required String searchName}) async* {
    try {
      yield* _firestoreDB
          .collection('items')
          .where('title', isEqualTo: searchName)
          .snapshots()
          .asyncMap<List<Item>>((event) async {
        List<Item> items = [];

        for (var doc in event.docs) {
          try {
            Item item = Item.fromJson(doc.data());
            item.itemID = doc.id;
            item.isMyFavourite = await checkIfItemIdIsFavourite(
                itemId: doc.id, dbUserId: currentDbUser);

            items.add(item);
          } catch (e) {
            throw Exception(e);
          }
        }
        return items;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Item>?> getMyFavouriteItems({required String dbUserId}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserId);
      final snapshot = await docUser.get();

      DbUser dbUser;
      if (snapshot.exists) {
        if (DbUser.fromJson(snapshot.data()!).itemFavourites != null) {
          if (DbUser.fromJson(snapshot.data()!).itemFavourites!.isNotEmpty) {
            dbUser = DbUser.fromJson(snapshot.data()!);

            List<Item> items = [];

            for (var itemId in dbUser.itemFavourites!) {
              final docItem = _firestoreDB.collection('items').doc(itemId);
              final snapshot = await docItem.get();

              if (snapshot.exists) {
                Item item = Item.fromJson(snapshot.data()!);
                item.itemID = snapshot.id;
                item.isMyFavourite = await checkIfItemIdIsFavourite(
                    itemId: snapshot.id, dbUserId: dbUserId);
                items.add(item);
              }
            }
            return items;
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  Future<List<Item>?> searchMyFavouriteItems(
      {required String dbUserId, required String searchName}) async {
    try {
      final docUser = _firestoreDB.collection('users').doc(dbUserId);
      final snapshot = await docUser.get();

      DbUser dbUser;
      if (snapshot.exists) {
        if (DbUser.fromJson(snapshot.data()!).itemFavourites != null) {
          if (DbUser.fromJson(snapshot.data()!).itemFavourites!.isNotEmpty) {
            dbUser = DbUser.fromJson(snapshot.data()!);

            List<Item> items = [];

            for (var itemId in dbUser.itemFavourites!) {
              final docItem = _firestoreDB.collection('items').doc(itemId);
              final snapshot = await docItem.get();

              if (snapshot.exists) {
                Item item = Item.fromJson(snapshot.data()!);
                item.itemID = snapshot.id;
                item.isMyFavourite = await checkIfItemIdIsFavourite(
                    itemId: snapshot.id, dbUserId: dbUserId);
                if (item.title == searchName) {
                  items.add(item);
                }
              }
            }
            return items;
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
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
