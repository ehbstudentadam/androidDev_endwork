import 'dart:io';
import 'package:drop_application/data/repository/firestore_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final _storage = FirebaseStorage.instance;
  final FirestoreRepository firestoreRepository = FirestoreRepository();

  Future<void> uploadImage(
      {required String itemID,
      required List<PlatformFile> filePickerResult}) async {
    try {
      List<PlatformFile> files = filePickerResult;

      for (var file in files) {
        final path = "auctions/$itemID/${file.name}";
        final fileToUpload = File(file.path!);

        //todo Compressing with package https://pub.dev/packages/flutter_image_compress

        final reference = _storage.ref().child(path);
        var uploadTask = reference.putFile(fileToUpload);
        final snapshot = await uploadTask.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        firestoreRepository.linkImageToItem(
            itemID: itemID, imageDownloadLink: urlDownload);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteAllImagesFromItem({required String itemId}) async {
    try {
      _storage.ref("auctions/$itemId").listAll().then((value) {
        for (var element in value.items) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        }
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
