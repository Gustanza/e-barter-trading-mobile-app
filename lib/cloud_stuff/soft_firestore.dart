import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebm_version_1_0/shared_stuff/post.dart';
import 'package:ebm_version_1_0/shared_stuff/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:uuid/uuid.dart';

class SoftFire {
  var softCloud = FirebaseFirestore.instance;
  var softAuth = FirebaseAuth.instance;
  Future<bool> heavyDuty(Post arg, CroppedFile picha) async {
    var softSRef = FirebaseStorage.instance.ref();
    Post post = arg;
    var postItself = const Uuid().v1();
    post.postItself = postItself;
    var softPRef = softSRef.child("exchangers/$postItself");

    try {
      await softPRef.putFile(File(picha.path));
      post.postLocation = await softPRef.getDownloadURL();

      await softCloud.collection(collectionYaPosts).doc().set(post.toSamsWay());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> areWe(String mimi, String yeye) async {
    var themchats = await FirebaseFirestore.instance
        .collection('zogo')
        .where('wahusika', arrayContains: mimi)
        .get();

    for (var thischat in themchats.docs) {
      if (thischat['wahusika'].contains(yeye)) {
        return thischat.id;
      }
    }
    return 'no-shit';
  }
}
