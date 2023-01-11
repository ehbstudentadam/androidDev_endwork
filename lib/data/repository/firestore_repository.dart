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
      final dbUser = DbUser(id: docUser.id, authUserID: authUserID);
      final json = dbUser.toJson();

      await docUser.set(json);
    } on Exception catch (e) {
      e.toString();
    }
  }

  Future<void> createItem(
      {required String authUserID,
      required String title,
      required String description,
      required double price}) async {
    try {
      final docItem = _firestoreDB.collection('items').doc();
      final item = Item(
          sellerID: authUserID,
          title: title,
          timestamp: DateTime.now(),
          description: description,
          price: price);
      final json = item.toJson();

      await docItem.set(json);
    } on Exception catch (e) {
      e.toString();
    }
  }

  Future<void> addImageToItem(
      {required String itemID, required String imageDownloadLink}) async {
    final docItem = _firestoreDB.collection('item').doc(itemID);
    docItem.update({
      'images': FieldValue.arrayUnion([imageDownloadLink])
    });
  }

  Future<DbUser?> getDBUserByDBUserId({required String dbUserID}) async {
    final docUser = _firestoreDB.collection('users').doc(dbUserID);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return DbUser.fromJson(snapshot.data()!);
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

  Stream<List<Bid>> getAllBidsByItemId({required String itemID}) => _firestoreDB
      .collection('bids')
      .where('itemID', isEqualTo: itemID)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Bid.fromJson(doc.data())).toList());

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

  Stream<List<Item>> getAllItems() =>
      _firestoreDB.collection('items').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());
}
