import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

Future<bool> uploadImage({
  required File image,
  required String userId,
}) =>
    FirebaseStorage.instance
        .ref(userId)
        .child(const Uuid().v4())
        .putFile(image)
        .then((_) => true)
        .catchError((_) => false);
