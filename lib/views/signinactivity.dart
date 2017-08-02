import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_database/firebase_database.dart'; //new
import 'package:petluvs/demo/animation_demo.dart';
import 'package:petluvs/views/myposts.dart';
import 'package:petluvs/views/mycommentspage.dart';
import 'package:petluvs/views/profilepage.dart';
import 'package:flutter_facebook_connect/flutter_facebook_connect.dart';
import 'package:petluvs/models/facebookgraph.dart';

GoogleSignIn googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics(); // new
final auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference(); // new
final peopleReference =
    FirebaseDatabase.instance.reference().child('people'); // new

final routes = <String, WidgetBuilder>{
  MyPostsPage.routeName: (BuildContext context) =>
      new MyPostsPage(title: "MyPostsPage"),
  AnimationDemo.routeName: (BuildContext context) => new AnimationDemo(),
  MyCommentsPage.routeName: (BuildContext context) => new MyCommentsPage(),
  ProfilePage.routeName: (BuildContext context) => new ProfilePage(),
  MyHomePage.routeName: (BuildContext context) => new MyHomePage(),
};

//handleFacebookSignIn(BuildContext context) async {
//  try {
//    print(auth.currentUser);
//
//    if (auth.currentUser == null) {
//      final facebookConnect = new FacebookConnect(const FacebookOptions(
//          appId: '300414633755870',
//          clientSecret: '8ed45af1c0253704ce25c76352888514'));
//
//      FacebookOAuthToken token = await facebookConnect.login();
//
//      FacebookGraph graph= new FacebookGraph(token);
//      PublicProfile profile = await graph.me(["name"]);
//      print('user'+profile.name);
//
//      final fbuser=token.access.toString().substring(1,9)+'@gmail.com';
//      print(fbuser);
//
//      auth.signInWithEmailAndPassword(email: fbuser, password: 'charan');
//
//      print(token.access);
//      peopleReference.child(auth.currentUser.uid).set({
//        '_search_index': {
//          'full_name': auth.currentUser.displayName,
//          'reversed_full_name':
//              auth.currentUser.displayName.split(' ').reversed.join(' '),
//        },
//        'full_name': auth.currentUser.displayName, //new
//        'profile_picture': auth.currentUser.photoUrl, //new
//      });
//
////      Navigator.pushNamed(context, MyPostsPage.routeName);
//    }
//  } catch (error) {}
//}

handleGoogleSignIn(BuildContext context) async {
  try {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
print("user"+user.email);
    if (user == null) {
      await googleSignIn.signIn();
//      analytics.logLogin();
    print(googleSignIn.currentUser);
    }

    if (auth.currentUser == null) {
      //new
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );

      peopleReference.child(auth.currentUser.uid).set({
        '_search_index': {
          'full_name': auth.currentUser.displayName,
          'reversed_full_name':
              auth.currentUser.displayName.split(' ').reversed.join(' '),
        },
        'full_name': auth.currentUser.displayName, //new
        'profile_picture': auth.currentUser.photoUrl, //new
      });

      Navigator.pushNamed(context, MyPostsPage.routeName);
    } else {
      Navigator.pushNamed(context, MyPostsPage.routeName);
    }
  } catch (error) {}
}

firebaseSignIn(BuildContext context) async {
  if (auth.currentUser != null) {
    Navigator.pushNamed(context, MyPostsPage.routeName);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Pet Luvs',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new MyHomePage(title: 'Pet Luvs'),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  static const String routeName = "/MyHomePage";

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class PersonData {
  String email = '';
  String password = '';
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = new GlobalKey<FormFieldState<String>>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  PersonData person = new PersonData();

  void googleSignIn() {
    handleGoogleSignIn(context);
//    CircularProgressIndicator indicator=new CircularProgressIndicator();
//    analytics.logEvent(name: 'send_user');
    Navigator.pushNamed(context, MyPostsPage.routeName);
  }

  String _validateEmail(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (!nameExp.hasMatch(value))
      return 'Please enter only email.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Container(
            child: new Image(
                image: new AssetImage('graphics/petloves.png'),
                width: screenSize.width),
            alignment: FractionalOffset.topCenter,
          ),
//          new Container(
//            padding: new EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
//            child: new Form(
//              child: new Column(
//                children: <Widget>[
//                  new TextFormField(
//                    decoration: const InputDecoration(
//                      icon: const Icon(
//                        Icons.email,
//                        color: Colors.blue,
//                      ),
//                      hintText: 'Please enter your Email address!',
//                      labelText: 'Email *',
//                    ),
//                    onSaved: (String value) {
//                      person.email = value;
//                    },
//                    validator: _validateEmail,
//                  ),
//                  new Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      new Expanded(
//                        child: new TextFormField(
//                          key: _passwordFieldKey,
//                          decoration: const InputDecoration(
//                            icon: const Icon(
//                              Icons.security,
//                              color: Colors.red,
//                            ),
//                            hintText: 'How do you log in?',
//                            labelText: 'Password *',
//                          ),
//                          obscureText: true,
//                          onSaved: (String value) {
//                            person.password = value;
//                          },
//                        ),
//                      ),
//                    ],
//                  ),
//                  new Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      new Container(
//                        padding: const EdgeInsets.all(20.0),
//                        alignment: const FractionalOffset(0.5, 0.5),
//                        child: new RaisedButton(
//                          child: const Text('Sign In'),
//                          onPressed: _handlePetluvsLogin,
//                        ),
//                      ),
//                      new Container(
//                        padding: const EdgeInsets.all(20.0),
//                        alignment: const FractionalOffset(0.5, 0.5),
//                        child: new RaisedButton(
//                          child: const Text('Sign Up'),
//                          onPressed: _handlePetluvsLogin,
//                        ),
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//          ),
          new Container(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new Center(
                    child: new Icon(Icons.arrow_downward),
                  ),
//
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: new InkWell(
                        child: new Image(
                          image: new AssetImage('graphics/google.png'),
                          width: screenSize.width / 8,
                        ),
                        onTap: (){handleGoogleSignIn(context);},
                      ),
                      padding: new EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                    ),
                    new Container(
                      child: new InkWell(
                        child: new Image(
                          image: new AssetImage('graphics/facebook.png'),
                          width: screenSize.width / 8,
                        ),
                        onTap: googleSignIn,
                      ),
                      padding: new EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                    ),
                    new Container(
                      child: new InkWell(
                        child: new Image(
                          image: new AssetImage('graphics/instagram.png'),
                          width: screenSize.width / 8,
                        ),
                        onTap: googleSignIn,
                      ),
                      padding: new EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  void _handlePetluvsLogin() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;  // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showInSnackBar('${person.email}\'s phone number is ${person.password}');
    }
  }
}
