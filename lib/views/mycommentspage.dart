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


final postsReference =
    FirebaseDatabase.instance.reference().child('posts'); // new
final userKey = auth.currentUser.uid;
final commentsReference =
FirebaseDatabase.instance.reference().child('comments');


final List<ChatMessage> messages = <ChatMessage>[]; // new


class MyCommentsPage extends StatefulWidget {
  MyCommentsPage({Key key,this.snapshot}) : super(key: key);

  static const String routeName = "/MyCommentsPage";

   final DataSnapshot snapshot;

//   static const String postRef = snapshot.key;


  @override
  MyCommentsPageState createState() => new MyCommentsPageState();
}

class MyCommentsPageState extends State<MyCommentsPage> {

  bool isComposing = false;


  final TextEditingController textController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text("Friendlychat"),
//          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
//        ),
        body: new Column(children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              query: commentsReference.child(widget.snapshot.key),
              sort: (a, b) => b.key.compareTo(a.key),
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
                return new ChatComment(
                    snapshot: snapshot,
                    animation: animation
                );
              },
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration:
            new BoxDecoration(color: Theme.of(context).cardColor),
            child: buildTextComposer(),
          ),
        ]));
  }


  Widget buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.photo_camera),
                  onPressed: () async {
//                    await _ensureLoggedIn();
                    File imageFile = await ImagePicker.pickImage();
                    int random = new Random().nextInt(100000);
                    StorageReference ref =
                    FirebaseStorage.instance.ref().child("image_$random.jpg");
                    StorageUploadTask uploadTask = ref.put(imageFile);
                    Uri downloadUrl = (await uploadTask.future).downloadUrl;
                    sendMessage(imageUrl: downloadUrl.toString());
                  }
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: textController,
                onChanged: (String text) {
                  setState(() {
                    isComposing = text.length > 0;
                  });
                },
                onSubmitted: handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                  child: new Text("Send"),
                  onPressed: isComposing
                      ? () => handleSubmitted(textController.text)
                      : null,
                )
                    : new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: isComposing
                      ? () => handleSubmitted(textController.text)
                      : null,
                )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border:
              new Border(top: new BorderSide(color: Colors.grey[200])))
              : null),
    );
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
//    MyCommentsPage cpage= new MyCommentsPage();
    commentsReference.child(widget.snapshot.key).push().set({
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': ServerValue.timestamp,
      'author':{
        'full_name': googleSignIn.currentUser.displayName,
        'profile_picture': googleSignIn.currentUser.photoUrl,
        'uid':auth.currentUser.uid,
      },

    });
    analytics.logEvent(name: 'send_message');
  }


}
