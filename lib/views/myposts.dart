import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_database/firebase_database.dart'; //new
import 'package:firebase_database/ui/firebase_animated_list.dart'; //new
import 'package:petluvs/extra/feed.dart';
import 'package:firebase_storage/firebase_storage.dart'; // new
import 'package:petluvs/extra/NewPostPage.dart';
import 'package:petluvs/extra/item.dart';
import 'package:petluvs/demo/animation_demo.dart';
import 'package:petluvs/models/post.dart';
import 'package:petluvs/views/signinactivity.dart';
import 'package:image_picker/image_picker.dart'; // new
import 'dart:math'; // new
import 'dart:io'; // new
import 'package:petluvs/models/grid_list_demo.dart';
import 'package:petluvs/views/mycommentspage.dart';
import 'package:petluvs/views/profilepage.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:petluvs/models/gridlist.dart';
import 'package:petluvs/views/navigation.dart';
import 'package:petluvs/demo/animation/home.dart';
import 'package:petluvs/models/searchtabs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:petluvs/views/notification.dart';

//final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

typedef AppBar AppBarCallback(BuildContext context);

final postsReference =
    FirebaseDatabase.instance.reference().child('posts'); // new
final userKey = auth.currentUser.uid;
final feedReference =
FirebaseDatabase.instance.reference().child('feed');
final peopleReference =
FirebaseDatabase.instance.reference().child('people');



onPostLike(DataSnapshot snapshot) {
//  signIn();

//      final userKey = auth.currentUser.uid;

//  print('u'+userKey);
  final DatabaseReference postLikeRef = databaseReference.child("likes");
  postLikeRef.child(snapshot.key).set({'$userKey': ServerValue.timestamp});
}

onComment(BuildContext context, DataSnapshot snapshot) {
  Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) =>
            new MyCommentsPage(snapshot: snapshot),
      ));

//      final userKey = auth.currentUser.uid;

//  print('u'+userKey);
//  final DatabaseReference commentRef = databaseReference.child("comments");
//  commentRef.child(snapshot.key).push().set(
//      {
//        'author':{
//          'full_name':auth.currentUser.displayName,
////          'profile_picture'
//        },
//      }
//  );
}

onProfileClicked(BuildContext context, DataSnapshot snapshot) {
  Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) => new ProfilePage(snapshot: snapshot),
      ));

//      final userKey = auth.currentUser.uid;

//  print('u'+userKey);
//  final DatabaseReference commentRef = databaseReference.child("comments");
//  commentRef.child(snapshot.key).push().set(
//      {
//        'author':{
//          'full_name':auth.currentUser.displayName,
////          'profile_picture'
//        },
//      }
//  );
}

firebaseSignOut(BuildContext context) async {
  if (auth.currentUser != null) {
    auth.signOut();

    Navigator.pushNamed(context, MyHomePage.routeName);
  }
}



class MyPostsPage extends StatefulWidget {
  MyPostsPage({Key key, this.title}) : super(key: key);

  static const String routeName = "/MyPostsPage";
  final String title;

  @override
  _MyPostsPageState createState() => new _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> with TickerProviderStateMixin{
//  _MyPostsPageState({this.snapshot});

  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  PageController _pageController;
  int _page = 0;
  StreamSubscription<Event> _messagesSubscription;
  bool _anchorToBottom = true;

  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;



//  final DataSnapshot snapshot;

//  DataSnapshot snapshot;




  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
//      appBar: new AppBar(
//        title: const Text('Bottom navigation'),
//        actions: <Widget>[
//          new PopupMenuButton<BottomNavigationBarType>(
//            onSelected: (BottomNavigationBarType value) {
//              setState(() {
//                _type = value;
//              });
//            },
//            itemBuilder: (BuildContext context) => <PopupMenuItem<BottomNavigationBarType>>[
//              const PopupMenuItem<BottomNavigationBarType>(
//                value: BottomNavigationBarType.fixed,
//                child: const Text('Fixed'),
//              ),
//              const PopupMenuItem<BottomNavigationBarType>(
//                value: BottomNavigationBarType.shifting,
//                child: const Text('Shifting'),
//              )
//            ],
//          )
//        ],
//      ),
//            appBar: new AppBar(
//
//        leading: new SizedBox(child: new Icon(Icons.pets)),
//        title: new Text("Pet Luvs",style: Theme.of(context).accentTextTheme.title,),
//        centerTitle: true,
//        backgroundColor: Colors.blueGrey,
//        actions: [searchBar.getSearchAction(context)],
//      ),
      body: new Center(
          child: _buildTransitionsStack()
      ),
      bottomNavigationBar: botNavBar,
    );
  }



//  @override
//  Widget build(BuildContext context) {
//    final Orientation orientation = MediaQuery.of(context).orientation;
//
//    Query postsQuery = postsReference;
//    postsQuery.onValue.listen((Event event) {
//      final postkey = event.snapshot.key;
//    });
//
//    return new Scaffold(
////      appBar: new AppBar(
////
////        leading: new SizedBox(child: new Icon(Icons.pets)),
////        title: new Text("Pet Luvs",style: Theme.of(context).accentTextTheme.title,),
////        centerTitle: true,
////        backgroundColor: Colors.blueGrey,
////        actions: [searchBar.getSearchAction(context)],
////      ),
//      body: new PageView(
//        children: <Widget>[
//          new Container(
//            child: new Scaffold(
//              appBar: new AppBar(
//                leading: new IconButton(
//                  icon: const Icon(Icons.undo),
//                  onPressed: () {
//                    firebaseSignOut(context);
//                  },
//                ),
//                title: new Text(
//                  "Pet Luvs",
//                  style: Theme.of(context).accentTextTheme.title,
//                ),
//                centerTitle: true,
//                backgroundColor: Colors.blueGrey,
//              ),
//              body: new FirebaseAnimatedList(
//                key: new ValueKey<bool>(_anchorToBottom),
//                query: postsReference,
////                reverse: _anchorToBottom,
//                sort: _anchorToBottom
//                    ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
//                    : null,
//                itemBuilder:
//                    (_, DataSnapshot snapshot, Animation<double> animation) {
////                print(snapshot.value);
////                  return new SizeTransition(
////                    sizeFactor: animation,
////
////                    child: new Text(snapshot.value['senderName'].toString()),
////                  );
//                  return new ChatMessage(
//                    snapshot: snapshot,
//                    animation: animation,
////                  postkey: postkey,
//
////                  child: new Text(snapshot.value['senderName'].toString()),
//                  );
////              return new Column(
////                  children: <Widget>[
////                    new Expanded(
////                        child: new GridView.count(
////                          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
////                          mainAxisSpacing: 4.0,
////                          crossAxisSpacing: 4.0,
////                          padding: const EdgeInsets.all(4.0),
////                          childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
////                          children: photos.map((Photo photo) {
////                            return new GridDemoPhotoItem(
////                                photo: photo,
////                                tileStyle: GridDemoTileStyle.twoLine,
////                                onBannerTap: (Photo photo) {
////                                  setState(() {
////                                    photo.isFavorite = !photo.isFavorite;
////                                  });
////                                }
////                            );
////                          }).toList(),
////                        )
////                    )
////                  ]
////              );
//
////                  snapshot: snapshot,
////                  animation: animation,
////                  postkey: postkey,
//
////                  child: new Text(snapshot.value['senderName'].toString()),
////                );
//                },
//              ),
//            ),
//          ),
//          new Container(
//            child: new Scaffold(
//              appBar: searchBar.build(context),
//              body: new FirebaseAnimatedList(
//                key: new ValueKey<bool>(_anchorToBottom),
//                query: _search == null
//                    ? postsReference
//                    : postsReference.orderByKey().limitToFirst(2),
//                sort: _anchorToBottom
//                    ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
//                    : null,
//                defaultChild: new CircularProgressIndicator(),
//                itemBuilder:
//                    (_, DataSnapshot snapshot, Animation<double> animation) {
//                  return new ChatMessage(
//                    snapshot: snapshot,
//                    animation: animation,
//                  );
//                },
//              ),
//            ),
//          ),
//          new Container(
//            child: imageFile == null
//                ? new Text("Please select Image")
//                : new Image.file(imageFile),
//          ),
//          new Container(color: Colors.pink),
//          new Container(color: Colors.yellow),
//        ],
//        controller: _pageController,
//        onPageChanged: onPageChanged,
//      ),
//      bottomNavigationBar: new BottomNavigationBar(
//        items: [
//          new BottomNavigationBarItem(
//              icon: new Icon(Icons.trending_up), title: new Text("Feed")),
//          new BottomNavigationBarItem(
//              icon: new Icon(Icons.search), title: new Text("Search")),
//          new BottomNavigationBarItem(
//              icon: new Icon(Icons.add), title: new Text("Add")),
//          new BottomNavigationBarItem(
//              icon: new Icon(Icons.notifications),
//              title: new Text("Notifications")),
//          new BottomNavigationBarItem(
//              icon: new Icon(Icons.person), title: new Text("Profile")),
//        ],
//        onTap: navigationTapped,
//        currentIndex: _page,
//      ),
//      floatingActionButton: new FloatingActionButton(
//          child: new Icon(Icons.add),
//          onPressed: _onFloatingActionButtonPressed),
//    );
//  }

//  void navigationTapped(int page) {
//    _pageController.animateToPage(page,
//        duration: const Duration(milliseconds: 300), curve: Curves.linear);
//  }

//  @override
//  void initState() {
//    super.initState();
//    _pageController = new PageController();
//    FirebaseDatabase.instance.setPersistenceEnabled(true);
//    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
////    _messagesSubscription =
////        peoplereference.limitToLast(10).onChildAdded.listen((Event event) {
//////          print('Child added: ${event.snapshot.value}');
//////          print('Uid'+peoplereference.child("uid").toString());
//////          print('gid'+_googleSignIn.currentUser.id);
////        });
//  }

  @override
  void initState() {
    super.initState();

    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.trending_up),
        title: const Text('Feed'),
        color: Colors.deepPurple,
        vsync: this,
        firebase:   new Container(
            child: new Scaffold(
    appBar: new AppBar(
                leading: new IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: () {
                    firebaseSignOut(context);
                  },
                ),
                title: new Text(
                  "Pet Luvs",
//                  style: Theme.of(context).accentTextTheme.title,
                ),
                centerTitle: true,
                backgroundColor: Colors.blueGrey,
              ),
              body: new FirebaseAnimatedList(
                key: new ValueKey<bool>(_anchorToBottom),
                query:  postsReference,
//                    : postsReference.orderByKey().limitToFirst(2),
                sort: _anchorToBottom
                    ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
                    : null,
                defaultChild: new Text("Hello From PetLuvs"),
                itemBuilder:
                    (_, DataSnapshot snapshot, Animation<double> animation) {
                  return new ChatMessage(
                    snapshot: snapshot,
                    animation: animation,
                  );
                },
              ),
            ),
          ),
      ),
      new NavigationIconView(
        icon: const Icon(Icons.search),
        title: const Text('Search'),
        color: Colors.deepOrange,
        vsync: this,
        firebase: new Container(
          child: new PersonSearch(),
        )
      ),


      new NavigationIconView(
        icon: const Icon(Icons.add),
        title: const Text('Add'),
        color: Colors.teal,
        vsync: this,
        firebase:new Container(
          child: new AnimationDemoHome(),
        ),
      ),
      new NavigationIconView(
        icon: const Icon(Icons.notifications),
        title: const Text('Notification'),
        color: Colors.indigo,
        vsync: this,
        firebase:

        new Container(
          child:new PushMessagingExample(),

//          new CustomScrollView(
//            slivers: <Widget>[
//              const SliverAppBar(
//                pinned: false,
//                expandedHeight: 250.0,
//                flexibleSpace: const FlexibleSpaceBar(
//                  title: const Text('Demo'),
//                ),
//              ),
//
//
//              new SliverGrid(
//                gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
//                  maxCrossAxisExtent: 200.0,
//                  mainAxisSpacing: 10.0,
//                  crossAxisSpacing: 10.0,
//                  childAspectRatio: 4.0,
//                ),
//                delegate: new SliverChildBuilderDelegate(
//                      (BuildContext context, int index) {
//                    return new Container(
//                      alignment: FractionalOffset.center,
//                      color: Colors.teal[100 * (index % 9)],
//                      child: new Text('grid item $index'),
//                    );
//                  },
//                  childCount: 20,
//                ),
//              ),
//              new SliverFixedExtentList(
//                itemExtent: 50.0,
//                delegate: new SliverChildBuilderDelegate(
//                      (BuildContext context, int index) {
//                    return new Container(
//                      alignment: FractionalOffset.center,
//                      color: Colors.lightBlue[100 * (index % 9)],
//                      child: new Text('list item $index'),
//                    );
//                  },
//                ),
//              ),
//            ],
//          )

        ),
      ),
      new NavigationIconView(
        icon: const Icon(Icons.person),
        title: const Text('Person'),
        color: Colors.pink,
        vsync: this,
      )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }


//  @override
//  void dispose() {
//    super.dispose();
//    _messagesSubscription.cancel();
//
//    _pageController.dispose();
//  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.listenable;
      final Animation<double> bAnimation = b.listenable;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

//  void onPageChanged(int page) {
//    setState(() {
//      this._page = page;
//    });
//  }
}
