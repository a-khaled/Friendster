import 'package:flutter/material.dart';

import '../screens/user_profile_screen.dart';

class PostItem extends StatefulWidget {
  final String username, post;
  bool isMe;
  var userId, followId;

  PostItem(this.username, this.post, this.isMe, [this.userId, this.followId]);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isFollowed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.followId);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileScreen(
                    widget.username, widget.userId, widget.followId)));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        height: 110,
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Container(
              height: 50,
              width: 50,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/profile.png'),
              )),
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    width: 220,
                    child: Text(
                      widget.post,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
