import 'package:flutter/material.dart';

import '../widgets/user_posts.dart';
import '../Functions/database_functions.dart';

class UserProfileScreen extends StatefulWidget {
  String username;
  var currentUid, otherUid;

  UserProfileScreen(this.username, this.currentUid, this.otherUid);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFollowing = false;

  void followOrUnfollow() {
    if (_isFollowing) {
      DatabaseFunctions.unFollow(widget.currentUid, widget.otherUid);
      setState(() {
        _isFollowing = false;
      });

    } else {
      DatabaseFunctions.follow(widget.currentUid, widget.otherUid);
      setState(() {
        _isFollowing = true;
      });
    }
  }

  void setupIsFollowing() async {
    bool isFollowingThisUser = await DatabaseFunctions.isFollowingUser(widget.currentUid, widget.otherUid);
    setState(() {
      _isFollowing = isFollowingThisUser;
    });
  }

  @override
  void initState() {
    super.initState();
    setupIsFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
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
                  width: 150,
                  margin: EdgeInsets.fromLTRB(30, 10, 20, 30),
                  child: Text(
                          widget.username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )

                ),
            OutlinedButton(
                      onPressed: followOrUnfollow,
                      child: Text(
                        !_isFollowing ? 'follow' : 'unfollow',
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              !_isFollowing ? Colors.blueAccent : Colors.red),
                          foregroundColor: MaterialStateProperty.all(Colors.white)),
                    ),
              ],
            ),
          ),
        ),
        Expanded(child: Container(child: UserPosts(widget.otherUid))),
      ]),
    );
  }
}
