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
import 'package:petluvs/models/gif.dart';
import 'package:share/share.dart';



//final uauth = FirebaseAuth.instance;





@override
class ChatMessage extends StatelessWidget {
  ChatMessage({this.snapshot, this.animation});
  final DataSnapshot snapshot;
  final Animation animation;
  static final double height =380.0;


  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle = theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    return new Container(
      padding: const EdgeInsets.all(2.0),
      height: height,
      child: new Card(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // photo and title
            new SizedBox(
              height: 300.0,
              child: new Stack(
                children: <Widget>[
                  new Positioned.fill(
                    child: new Image.network(
                      snapshot.value['full_url'],
                      fit: BoxFit.cover,
                    ),
//                  child: new Gif(url:snapshot.value['full_url'].toString()),
                  ),
                  new Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 340.0,
                    top: 220.0,
                    child: new IconButton(
                        icon: new CircleAvatar(
                            backgroundImage: new NetworkImage(
                                snapshot.value['author']['profile_picture'])),
                        onPressed: () {onProfileClicked(context,snapshot);}),
//                        style: titleStyle,
//                      ),
                    ),
                  new Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 230.0,
                    top: 220.0,
                    child: new MaterialButton(
                        child: new Text(
                          snapshot.value['author']['full_name'],
                        ),
                        onPressed: () {onProfileClicked(context,snapshot);}),
//                        style: titleStyle,
//                      ),
                  ),
//                  ),
                ],
              ),
            ),

              new Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: new DefaultTextStyle(
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: descriptionStyle,
                  child:
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      new ButtonTheme.bar(
                        child: new ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: <Widget>[

                            new IconButton(icon: new Icon(Icons.pets,color: Colors.red,), onPressed: () {onPostLike(snapshot);},),
                    new IconButton(
                      padding:const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                      icon: new Icon(Icons.comment, color: Colors.red,), onPressed: () {onComment(context,snapshot);},),
                            new IconButton(icon: new Icon(Icons.share,color: Colors.red,), onPressed: () {share(snapshot.value['full_url']);},),


//                            new FlatButton(
//                              child: const Text('SHARE'),
//                              textColor: Colors.amber.shade500,
//                              onPressed: () { /* do nothing */ },
//                            ),
//                            new FlatButton(
//                              child: const Text('EXPLORE'),
//                              textColor: Colors.amber.shade500,
//                              onPressed: () { /* do nothing */ },
//                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

//  Widget build(BuildContext context) {
//
//    final Size screenSize = MediaQuery.of(context).size;;
//
//
//    return new SizeTransition(
//      sizeFactor: new CurvedAnimation(
//          parent: animation, curve: Curves.easeOut),
//      axisAlignment: 0.0,
//
//      child: new Container(
//        margin: const EdgeInsets.symmetric(vertical: 5.0),
//        child: new Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//
//            new Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                new Row(
//            children: <Widget>[
//              new Container(
//                margin: const EdgeInsets.only(right: 8.0),
//
//                child: new IconButton(icon: new CircleAvatar(backgroundImage: new NetworkImage(snapshot.value['author']['profile_picture'])), onPressed: () {onProfileClicked(context,snapshot);}),
//              ),
//              new Text(
//                  snapshot.value['author']['full_name'],
//                  style: Theme.of(context).textTheme.subhead),
//            ],
//        ),
//
//                new Container(
//                  margin: const EdgeInsets.only(top: 5.0),
//                  child: snapshot.value['author']['profile_picture'] != null ?
//                  new Image.network(
//                    snapshot.value['full_url'],
//                    width: screenSize.width,
//                  ) :
//                  new Text("text"),
//                ),
//                new Row(
//                  children: <Widget>[
//                    new IconButton(icon: new Icon(Icons.pets), onPressed: () {onPostLike(snapshot);},),
//                    new IconButton(icon: new Icon(Icons.comment), onPressed: () {onComment(context,snapshot);},),
//
//                  ],
//                ),
//              ],
//            ),
//          ],
//        ),
//
//      ),
//    );
//  }
}