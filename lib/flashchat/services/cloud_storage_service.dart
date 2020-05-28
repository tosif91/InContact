import 'dart:io';

import 'package:advancetut/flashchat/services/local_storage_service.dart';
import 'package:advancetut/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class CloudStorageService{
  final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'https://console.firebase.google.com/project/flashchat-55fbf/storage/flashchat-55fbf.appspot.com/files');
  final StorageReference _ref=FirebaseStorage.instance.ref();
  final LocalStorageService _localStorageService=locator<LocalStorageService>();
  String fileName;
  StorageUploadTask uploadFile(String groupId,File file){
   fileName='${Timestamp.now().millisecondsSinceEpoch}';
  return _ref.child(groupId).child(fileName).putFile(file);
  }
  downloadFile(String path,File file)async{

  }
}
