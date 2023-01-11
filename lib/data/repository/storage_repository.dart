import 'dart:io';
import 'package:drop_application/data/models/item.dart';
import 'package:drop_application/data/repository/firestore_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final _storage = FirebaseStorage.instance;
  final FirestoreRepository firestoreRepository = FirestoreRepository();

  Future<String> uploadImage(
      {
      required String itemID,
      required PlatformFile file,
      required UploadTask uploadTask}) async {

    final path = "$itemID/${file.name}";
    final fileToUpload = File(file.path!);

    final reference = _storage.ref().child(path);
    uploadTask = reference.putFile(fileToUpload);

    final snapshot = await uploadTask.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    firestoreRepository.addImageToItem(
        itemID: itemID, imageDownloadLink: urlDownload);

    return urlDownload;
  }

  Future<String?> downloadURL(String itemID) async {
    final Item? item = await firestoreRepository.getItemByItemId(itemID: itemID);
    String? imageUrl = item?.images?.first;
    if (imageUrl == null) return null;

    //String downloadUrl = await _storage.ref("$itemID/$imageUrl")
  }

/*  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState((){
      pickedFile = result.files.first;
    });
  }*/

}
