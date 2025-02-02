import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digislip/models/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String uid;
  final String email;

  DatabaseService({required this.uid, required this.email});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference merchantsCollection =
      FirebaseFirestore.instance.collection('Merchants');

  final FirebaseStorage storage = FirebaseStorage.instance;

  // Create voucher
  Future<void> createVoucherData() async {
    final DocumentReference userDoc = usersCollection.doc(uid);
    final CollectionReference vouchersCollection =
        userDoc.collection('Vouchers');

    final snapshot = await vouchersCollection.get();
    if (snapshot.docs.isEmpty) {
      await vouchersCollection.add({
        "Expirydate": "September 14, 2023 at 2:01:01 AM UTC+2",
        "Isused": false,
        "Merchantid": "zJHvK35B8nfwy82PHHP8",
        "Terms": "This voucher gives you a 10% discount on any 2 tennis balls.",
        "Type": "Json",
        "Useddate": "July 12, 2023 at 2:00:00 PM UTC+2",
        "Voucherdate": "July 12, 2023 at 9:09:48 AM UTC+2",
        "Vouchernumber": "611000609009504"
      });
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
        'Email': email,
        'Id': uid,
      });
    }
  }

  // Get user data
  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_fromUserDataFromSnapshot);
  }

  // Get receipts
  Stream<List<Map<String, String>>> getReceipts() {
    final DocumentReference userDoc = usersCollection.doc(uid);
    final CollectionReference receiptsCollection =
        userDoc.collection('Receipts');

    return receiptsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final receiptData = {
          'Data': _getFieldValue(doc, 'Data'),
          'Receiptdate': _getFieldValue(doc, 'Receiptdate'),
          'Receipttime': _getFieldValue(doc, 'Receipttime'),
          'Receiptnumber': _getFieldValue(doc, 'Receiptnumber'),
          'Source': _getFieldValue(doc, 'Source'),
          'Merchantid': _getFieldValue(doc, 'Merchantid'),
          'Merchantname': _getFieldValue(doc, 'Merchantname'),
          'Storename': _getFieldValue(doc, 'Storename'),
          'Receiptid': doc.id.toString(),
          'Type': _getFieldValue(doc, 'Type'),
        };
        return receiptData;
      }).toList();
    });
  }


  Stream<List<Map<String, String>>> getVouchers() {
    final DocumentReference userDoc = usersCollection.doc(uid);
    final CollectionReference vouchersCollection =
    userDoc.collection('Vouchers');

    return vouchersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final voucherData = {
          'Expirydate': _getFieldValue(doc, 'Expirydate'),
          'Isused': _getFieldValue(doc, 'Isused'),
          'Merchantid': _getFieldValue(doc, 'Merchantid'),
          'Merchantname': _getFieldValue(doc, 'Merchantname'),
          'Storename': _getFieldValue(doc, 'Storename'),
          'Terms': _getFieldValue(doc, 'Terms'),
          'Type': _getFieldValue(doc, 'Type'),
          'Useddate': _getFieldValue(doc, 'Useddate'),
          'Voucherdate': _getFieldValue(doc, 'Voucherdate'),
          'Vouchertime': _getFieldValue(doc, 'Vouchertime'),
          'Vouchernumber': _getFieldValue(doc, 'Vouchernumber'),
        };
        return voucherData;
      }).toList();
    });
  }

  // Check if field exists, if it does not return empty string
  String _getFieldValue(DocumentSnapshot doc, String fieldName) {
    try {
      return doc.get(fieldName).toString();
    } catch (e) {
      return '';
    }
  }

  // Get Receipt Lines
  Future<List<Map<String, String>>> getLines(String receiptId) async {
    final DocumentReference userDoc = usersCollection.doc(uid);
    final CollectionReference receiptsCollection = userDoc.collection('Receipts');
    final CollectionReference receiptLinesCollection = receiptsCollection.doc(receiptId).collection('Receiptlines');

    final QuerySnapshot snapshot = await receiptLinesCollection.get();

    return snapshot.docs.map((doc) {
      final receiptLines = {
        'Amount': _getFieldValue(doc, 'Amount'),
        'Description': _getFieldValue(doc, 'Description'),
        'Linenumber': _getFieldValue(doc, 'Linenumber'),
        'Qty': _getFieldValue(doc, 'Qty'),
      };
      return receiptLines;
    }).toList();
  }

  Future<List<Map<String, String>>> getMerchants() async {
    try {
      QuerySnapshot snapshot = await merchantsCollection.get();
      List<Map<String, String>> merchantsList = [];

      for (var doc in snapshot.docs) {
        String id = doc.get('Id').toString();
        String name = doc.get('Name').toString();
        Map<String, String> merchant = {'Id': id, 'Name': name};
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

    await receiptsCollection.add({
      'Data': data,
      'Receiptdate': date,
      'Merchantid': merchantId,
      'Merchantname': merchantName,
      'Type': type,
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

  // get receipt picture url
  Future<String> getReceiptImage(String imageUrl) async {
    try {
      final downloadUrl =
          await FirebaseStorage.instance.ref().child(imageUrl).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return '';
    }
  }
}
