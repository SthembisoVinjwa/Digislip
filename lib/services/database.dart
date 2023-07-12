import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_data.dart';

class DatabaseService {
  final String uid;
  final String email;

  DatabaseService({required this.uid, required this.email});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('UserData');

  final CollectionReference merchantsCollection =
      FirebaseFirestore.instance.collection('Merchants');

  final FirebaseStorage storage = FirebaseStorage.instance;

  // Create receipt
  Future<void> createReceiptData() async {
    final DocumentReference userDoc = usersCollection.doc(uid);
    final CollectionReference receiptsCollection =
        userDoc.collection('Receipts');

    final snapshot = await receiptsCollection.get();
    if (snapshot.docs.isEmpty) {
      await receiptsCollection.add({'initialize': 0});
    }
  }

  // Create voucher
  Future<void> createVoucherData() async {
    final DocumentReference userDoc = usersCollection.doc(uid);
    final CollectionReference vouchersCollection =
        userDoc.collection('Vouchers');

    final snapshot = await vouchersCollection.get();
    if (snapshot.docs.isEmpty) {
      await vouchersCollection.add({'initialize': 0});
    }
  }

  // Create user record on database
  Future<void> createUserData() async {
    bool exists = await usersCollection
        .doc(uid)
        .get()
        .then((snapshot) => snapshot.exists);

    if (!exists) {
      await usersCollection.doc(uid).set({
        'Id': uid,
        'email': email,
      });
    }
  }

  // Get user data
  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_fromUserDataFromSnapshot);
  }

  Future<List<Map<String, String>>> getMerchants() async {
    try {
      QuerySnapshot snapshot = await merchantsCollection.get();
      List<Map<String, String>> merchantsList = [];

      for (var doc in snapshot.docs) {
        String id = doc.id;
        String name = doc.get('Name');
        Map<String, String> merchant = {'id': id, 'name': name};
        merchantsList.add(merchant);
      }

      return merchantsList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Convert snapshot to Custom user
  UserData _fromUserDataFromSnapshot(DocumentSnapshot snapshot) {
    String id = snapshot.get('Id');
    String email = snapshot.get('email');

    return UserData(
      uid: id,
      email: email,
    );
  }

  // Upload Receipt Picture to Database
  Future<void> updateReceiptPicture(String data, String date, String merchantId,
      String merchantName, String type) async {
    final DocumentReference userDoc = usersCollection.doc(uid);
    final CollectionReference receiptsCollection =
        userDoc.collection('Receipts');

    final snapshot = await receiptsCollection.get();

    await receiptsCollection.add({
      'data': data,
      'date': date,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'type': type,
    });
  }

  // Store receipt
  Future<String> uploadReceiptPicture(
      Uint8List imageBytes, String filename) async {
    try {
      final Reference storageReference =
          storage.ref().child('Users/$uid/$filename');
      final UploadTask uploadTask = storageReference.putData(imageBytes);
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return '';
    }
  }
}
