import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; //new
import 'package:firebase_storage/firebase_storage.dart'; // new
import 'package:petluvs/demo/animation_demo.dart';
import 'package:petluvs/models/post.dart';
import 'package:petluvs/views/signinactivity.dart';
import 'package:image_picker/image_picker.dart'; // new
import 'dart:math'; // new
import 'dart:io'; // new
import 'package:petluvs/models/comment.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:petluvs/models/profile.dart';
import 'package:petluvs/models/follow.dart';


final postsReference =
FirebaseDatabase.instance.reference().child('posts'); // new
final userKey = auth.currentUser.uid;
final commentsReference =
FirebaseDatabase.instance.reference().child('comments');
final followersReference =
FirebaseDatabase.instance.reference().child('followers');
final feedReference =
FirebaseDatabase.instance.reference().child('feed');




class ProfilePage extends StatefulWidget {
  ProfilePage({Key key,this.snapshot}) : super(key: key);

  static const String routeName = "/ProfilePage";

  final DataSnapshot snapshot;

//   static const String postRef = snapshot.key;


  @override
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  bool isComposing = false;


  final TextEditingController textController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    final uid=widget.snapshot.value['author']['uid'];
    print('uid:'+uid.toString());
    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text("Friendlychat"),
//          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
//        ),
        body: new Column(children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
             
              query: peopleReference.orderByKey().equalTo(uid),


//              sort: (a, b) => b.key.compareTo(a.key),
              padding: new EdgeInsets.all(8.0),
//              reverse: true,
              itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
//                print('db'+peopleReference.child(uid).toString());
                return new Profile(

                    snapshot: snapshot,
                    animation: animation
                );
              },
            ),
          ),
//          new Divider(height: 1.0),
          new IconButton(
            icon: const Icon(Icons.nature_people),
            iconSize: 50.0,
            onPressed: (){handleSubmitted(uid);
//            new FirebaseAnimatedList(
//                query: peopleReference.orderByKey().equalTo(uid), itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
////                print('db'+peopleReference.child(uid).toString());
//              return new Follow(
//
//                  snapshot: snapshot,
//                  animation: animation
//              );
//            });
            },
          ),
        ]));
  }




  Future<Null> handleSubmitted(String text) async {
    textController.clear();
    setState(() {
      isComposing = false;
    });
//    await _ensureLoggedIn();
    sendMessage(text: text);
  }

  void sendMessage({ String text, String imageUrl }) {
    final myid=auth.currentUser.uid;
//    MyCommentsPage cpage= new MyCommentsPage();
    followersReference.child(text).set({

        '$myid':true,


    });
    peopleReference.child(myid).child('following').child(text).set(true);

//    Future<DataSnapshot> snapshot=peopleReference.child(text).child('posts').once();
//
//    snapshot.then(feedReference.child(myid).push().set(true));


    analytics.logEvent(name: 'follow_message');
  }


}
