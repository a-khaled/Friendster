import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/post_item.dart';
import '../widgets/user_posts.dart';
import '../widgets/new_post.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userId = FirebaseAuth.instance.currentUser.uid;

  String _post = '';

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();
      addNewPost(_post.trim());
      Navigator.of(context).pop();
    }
  }

  void addNewPost(String post) async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'post': post,
        'userId': userId,
        'username': userData['username'],
      });
    } on Exception catch (e) {
      var message = 'An error occurred';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Row(
              children: [
                Container(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.png'),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 10, 20, 30),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get(),
                    builder: (ctx, snapshot) {
                      return Text(
                        snapshot.data['username'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container(child: UserPosts())),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add a new post'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Any thoughts ...'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Post can\'t be empty';
                      }
                      else if (value.length > 100) {
                        return 'Post can\'t be more than 100 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _post = value;
                    },
                  ),
                ),
                actions: [
                  ElevatedButton(onPressed: _submit, child: Text('Add post')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel')),
                ],
              );
            }),
      ),
    );
  }
}
