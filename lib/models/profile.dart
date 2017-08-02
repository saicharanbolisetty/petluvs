import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petluvs/views/signinactivity.dart';
import 'package:petluvs/views/myposts.dart';
import 'package:petluvs/views/profilepage.dart';

//final uauth = FirebaseAuth.instance;
import 'package:petluvs/views/mycommentspage.dart';

const String _name = "Your Name";


@override
class Profile extends StatelessWidget {
  Profile({this.snapshot, this.animation});
  final DataSnapshot snapshot;
  final Animation animation;

  Widget build(BuildContext context) {
    print('profile key:'+snapshot.key.toString());
    print('profile value:'+snapshot.value.toString());


    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(backgroundImage: new NetworkImage(snapshot.value['profile_picture'])),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                    snapshot.value['full_name'],
                    style: Theme.of(context).textTheme.subhead),
//                new Container(
//                  margin: const EdgeInsets.only(top: 5.0),
//                  child: snapshot.value['imageUrl'] != null ?
//                  new Image.network(
//                    snapshot.value['imageUrl'],
//                    width: 250.0,
//                  ) :
//                  new Text(snapshot.value['text']),
//                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

