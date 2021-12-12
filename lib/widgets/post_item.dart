import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String username, post;
  bool isMe;

  PostItem(this.username, this.post, this.isMe);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                username,
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
                    post,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
        !isMe ? OutlinedButton(
          onPressed: () {},
          child: Text('follow'),
        ) : Container()
      ]),
    );
  }
}
