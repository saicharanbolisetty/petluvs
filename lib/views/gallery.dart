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
File imageFile;
Uri downloadUrl;




class GalleryPage extends StatefulWidget {
  GalleryPage({Key key}) : super(key: key);

  static const String routeName = "/GalleryPage";


//   static const String postRef = snapshot.key;


  @override
  GalleryPageState createState() => new GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {

  bool isComposing = false;


  final TextEditingController textController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return new Container(
            child: imageFile == null
                ? new IconButton(icon: new Icon(Icons.pets), onPressed: (){onFloatingActionButtonPressed();})
                : new Image.file(imageFile),

    );
  }

  onFloatingActionButtonPressed() async {
//  _googleSignIn.signOut();
//    Navigator.pushNamed(context, AnimationDemo.routeName);
//    await handleGoogleSignIn(context);
    var _fileName = await ImagePicker.pickImage();
    final newPostKey = postsReference.push().key;
    setState(() {
      imageFile = _fileName;
    });
    int random = new Random().nextInt(100000); //new
    DateTime dateTime = new DateTime.now();

    StorageReference ref = //new
    FirebaseStorage.instance
        .ref()
        .child(auth.currentUser.uid.toString())
        .child("full")
        .child(dateTime.toString())
        .child("image$random.jpg"); //new
    StorageUploadTask uploadTask = ref.put(imageFile); //new
    downloadUrl = (await uploadTask.future).downloadUrl;

    peopleReference
        .child(auth.currentUser.uid)
        .child("posts")
        .child(newPostKey)
        .set(true);
    //          'uid':auth.currentUser.uid.toString(),
//
////        'text': text,                                                //new
//          'senderName': googleSignIn.currentUser.displayName, //new
//          'senderPhotoUrl': googleSignIn.currentUser.photoUrl, //new

    postsReference.child(newPostKey).set({
      'author': {
        'full_name': googleSignIn.currentUser.displayName,
        'profile_picture': googleSignIn.currentUser.photoUrl,
        'uid': auth.currentUser.uid,
      },
      'full_url': downloadUrl.toString(),
      'text': "Hey",
      'timestamp': dateTime.toString(),

//          'uid':auth.currentUser.uid.toString(),
//
////        'text': text,                                                //new
//          'senderName': googleSignIn.currentUser.displayName, //new
//          'senderPhotoUrl': googleSignIn.currentUser.photoUrl, //new
    });

    feedReference.child(auth.currentUser.uid).child(newPostKey).set(true);
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
