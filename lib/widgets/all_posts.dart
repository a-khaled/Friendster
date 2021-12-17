import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/post_item.dart';

class AllPosts extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser.uid;
  var followUid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isNotEqualTo: userId)
          .snapshots(),
      builder: (ctx, postSnapshot) {
        if (postSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final postDocs = postSnapshot.data.docs;
        print(postDocs);
        return ListView.builder(
            itemCount: postDocs.length,
            itemBuilder: (ctx, index) => PostItem(
                  postDocs[index]['username'],
                  postDocs[index]['post'],
                  postDocs[index]['userId'] == userId,
                  userId,
                  postDocs[index]['userId'],
                ));
      },
    );
  }
}
