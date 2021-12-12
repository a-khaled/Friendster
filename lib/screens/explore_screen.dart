import 'package:flutter/material.dart';

import '../widgets/all_posts.dart';

class ExploreScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: [
          Expanded(child: Container(child: AllPosts())),
        ],)
    );
  }
}
