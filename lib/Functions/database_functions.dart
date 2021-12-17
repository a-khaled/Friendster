import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFunctions  {


  static void follow(var userId,var followUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId).collection('following').doc(followUid).set({});
    FirebaseFirestore.instance
        .collection('users')
        .doc(followUid).collection('followers').doc(userId).set({});
  }

  static void unFollow(String userId,String followUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId).collection('following').doc(followUid).get().then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(followUid).collection('followers').doc(userId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(String userId,String followUid) async {
    DocumentSnapshot followingDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId).collection('following').doc(followUid).get();
    return followingDoc.exists;
  }


}
