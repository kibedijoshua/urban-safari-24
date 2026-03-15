import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String path) async {
    final ref = _storage.ref().child(path);
    final snapshot = await ref.putFile(file);
    return await snapshot.ref.getDownloadURL();
  }

  Future<String> uploadImageBytes(dynamic bytes, String path) async {
    final ref = _storage.ref().child(path);
    final snapshot = await ref.putData(bytes);
    return await snapshot.ref.getDownloadURL();
  }
}
