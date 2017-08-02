import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart'; //new
import 'package:petluvs/models/post.dart';
import 'package:petluvs/views/myposts.dart';

SearchBar searchBar;
bool _anchorToBottom = true;

class PersonSearch extends StatefulWidget {
  PersonSearch({Key key, this.newvalue}) : super(key: key);
  String newvalue;

  @override
  PersonSearchState createState() => new PersonSearchState();
}
//class ChecklistItem {
//  ChecklistItem({this.title, this.note, this.isSelected});
//
//  String title;
//  String note;
//  bool isSelected;
//}
//class Checklist {
//
//  Checklist({List<FirebaseAnimatedList> items}) : this._items = items;
//
//  // properties
//  List<FirebaseAnimatedList> _items = <FirebaseAnimatedList>[];
//
//  FirebaseAnimatedList operator [](int index) => _items[index];
//
//  // methods
//  List<FirebaseAnimatedList> items() { return _items; }
//
//  void clear() {
//    _items = <FirebaseAnimatedList>[];
//  }
//
//  void addItem(FirebaseAnimatedList item, {int index = -1}) {
//    if (index == -1) {
//      _items.add(item);
//    } else {
//      _items.insert(index, item);
//    }
//  }
//
//  void removeItemAtIndex(int index) {
//    _items.removeAt(index);
//  }
//
//  void removeItem(FirebaseAnimatedList item) {
//    _items.remove(item);
//  }
//
//}

//class AnimatedChecklist extends Checklist {
//  // todo (kg) - make required params required with @required annotation
//  AnimatedChecklist({List<FirebaseAnimatedList> items}) : super(items: items);
//
////  final dynamic removedItemBuilder;
////  final GlobalKey<AnimatedListState> listKey;
//
////  AnimatedListState get _animatedList => listKey.currentState;
//
//  @override
//  void addItem(FirebaseAnimatedList item, {int index = -1}) {
//    super.addItem(item, index: index);
//    if (index == -1) {
//      _animatedList.insertItem(items().length);
//    } else {
//      _animatedList.insertItem(index);
//    }
//  }
//}

class PersonSearchState extends State<PersonSearch> {

  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
//  AnimatedChecklist _checklist;
  FirebaseAnimatedList item;
  bool pressed=true;



//  _checklist = new AnimatedChecklist(
//  listKey: _listKey,
//  removedItemBuilder: _buildRemovedItem,
//  items: defaultItems,
//  );


  @override
  Widget build(BuildContext context) {
    return new Material(
      color: const Color(0xFFFFFFFF),
      child: _contentWidget(),
    );
  }

  Widget _contentWidget() {
    return new Column(
      children: [
        _buildInputField(),

        pressed==true?
        new CircularProgressIndicator():_buildListView(),

//        pressed==false?_buildListView():new Text("hi"),
      ],
    );
  }


//  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
//    return new Expanded(
//      child: new FirebaseAnimatedList(
//          key: new ValueKey<bool>(_anchorToBottom),
//          query: peopleReference
//              .orderByChild('full_name')
//              .startAt(newvalue.toString()),
////                    : postsReference.orderByKey().limitToFirst(2),
//          sort: _anchorToBottom
//              ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
//              : null,
//          defaultChild: new Text(
//            "Hello From PetLuvs",
////        style: Theme.of(context).textTheme.title
//          ),
//          itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
//            return new Text(
//                snapshot.key.toString() + snapshot.value.toString());
//          }),
//    );
//  }

  Widget _buildListView() {
//    pressed=false;
//    return new Text(newvalue);

//    return new Expanded(
//      child: new AnimatedList(
//        key: _listKey,
////        initialItemCount: _checklist.items().length,
//        itemBuilder: _buildItem,
//      ),
//    );
    return new Expanded(
      child: new FirebaseAnimatedList(
          key: new ValueKey<bool>(_anchorToBottom),
          query: peopleReference
              .orderByChild('full_name')
              .startAt(newvalue.toString()),
//                    : postsReference.orderByKey().limitToFirst(2),
          sort: _anchorToBottom
              ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
              : null,
          defaultChild: new Text(
            "Hello From PetLuvs",
//        style: Theme.of(context).textTheme.title
          ),
          itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
            return new Text(
                snapshot.key.toString() + snapshot.value.toString());
          }),
    );
  }

//  AnimatedChecklist _checklist;

//  _checklist = new AnimatedChecklist(
//  listKey: _listKey,
//  removedItemBuilder: _buildRemovedItem,
//  items: defaultItems,
//  );

  final TextEditingController _controller = new TextEditingController();
  String newvalue;
//  const pressed=true;


  Widget _buildInputField() {
    return new Container(
      color: const Color(0xFFF7F7F7),
      height: 60.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          new Material(
            color: new Color(0xFFF7F7F7),
            child: new IconButton(
              icon: new Icon(
                Icons.add,
                color: const Color(0xFF54C5F8),
              ),
              onPressed: () {

                if (_controller.text.length > 0) {
//                  ChecklistItem item = new ChecklistItem(
//                      title: _controller.text, isSelected: false);
                  setState(() {
                    if(pressed){
                      pressed=false;
                    }
                    else pressed=true;
                    newvalue=_controller.text;

                    _controller.clear();
//                    pressed=false;
                  });
                }
              },
            ),
          ),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: new TextField(
                controller: _controller,
                decoration: new InputDecoration(
                  hintText: 'Enter your note',
                  hideDivider: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
//class PersonSearch extends StatefulWidget {
//  PersonSearch({Key key,this.newvalue}) : super(key: key);
//  String newvalue;
//
//  @override
//  PersonSearchState createState() => new PersonSearchState();
//}
//
//class PersonSearchState extends State<PersonSearch> {
//  bool _active = false;
//
////  void _handleTap() {
////    setState(() {
////      _active = !_active;
////    });
////  }
//
//  Widget build(BuildContext context) {
//    return new FirebaseAnimatedList(
//      key: new ValueKey<bool>(_anchorToBottom),
//      query: peopleReference.orderByChild('full_name').startAt(
//          widget.newvalue.toString()),
////                    : postsReference.orderByKey().limitToFirst(2),
//      sort: _anchorToBottom
//          ? (DataSnapshot a, DataSnapshot b) =>
//          b.key.compareTo(a.key)
//          : null,
//      defaultChild: new Text("Hello From PetLuvs",
////        style: Theme.of(context).textTheme.title
//      ),
//      itemBuilder: (_, DataSnapshot snapshot,
//          Animation<double> animation) {
//        return new Text(snapshot.key.toString() + snapshot.value.toString());
////                      return new ChatMessage(
////                        snapshot: snapshot,
////                        animation: animation,
////                      );
//      },
//    );
//  }
//}
//
//class SearchTabs extends StatefulWidget {
//  SearchTabs({Key key}) : super(key: key);
//
//  static const String routeName = "/SearchTabsPage";
//
//  @override
//  SearchTabsState createState() => new SearchTabsState();
//}
//
//class Pageno {
//  Pageno({this.page});
//
//  final String page;
//
//  String get id => page[0];
//}
//
//class Pagelabel {
//  const Pagelabel({this.label});
//
//  final String label;
//}
//
//final Map<Pageno, Pagelabel> pages = <Pageno, Pagelabel>{
//  new Pageno(page: 'PLACE'): const Pagelabel(label: 'PLACE'),
//  new Pageno(page: 'PERSON'): const Pagelabel(label: 'PERSON'),
//};
//
//Widget personcontainer(String newvalue){
//  return new FirebaseAnimatedList(
//    key: new ValueKey<bool>(_anchorToBottom),
//    query: peopleReference.orderByChild('full_name').startAt(newvalue.toString()),
////                    : postsReference.orderByKey().limitToFirst(2),
//    sort: _anchorToBottom
//        ? (DataSnapshot a, DataSnapshot b) =>
//        b.key.compareTo(a.key)
//        : null,
//    defaultChild: new Text("Hello From PetLuvs",
////        style: Theme.of(context).textTheme.title
//    ),
//    itemBuilder: (_, DataSnapshot snapshot,
//        Animation<double> animation) {
//      return new Text(snapshot.key.toString()+snapshot.value.toString());
////                      return new ChatMessage(
////                        snapshot: snapshot,
////                        animation: animation,
////                      );
//    },
//  );
//}
//
//
//
//
//class SearchTabsState extends State<SearchTabs> {
////  String _search;
////
////  AppBar buildAppbar(BuildContext context) {
//////    print(context);
////
////    return new AppBar(
//////        title: new Text('PetLuvs'),
////        actions: [searchBar.getSearchAction(context)]);
////  }
////
////  void onSubmitted(String value) {
////    setState(() {
////      _search = value;
////    });
////  }
//
////  SearchTabsState() {
////    searchBar = new SearchBar(
////        inBar: true,
////        setState: setState,
////        colorBackButton: false,
////        buildDefaultAppBar: buildAppbar,
////        onSubmitted: onSubmitted);
////  }
//
//  final TextEditingController _controller = new TextEditingController();
//  String newvalue,newvalue1;
//
//  @override
//  Widget build(BuildContext context) {
//    return new DefaultTabController(
//      length: 2,
//      child: new Scaffold(
//        body: new NestedScrollView(
//          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//            return <Widget>[
//              new SliverAppBar(
//                title: new TextField(
//                  controller: _controller,
//                  decoration: new InputDecoration(
//                    hintText: 'Search',
//                  ),
//                  onChanged: (value){
//                    setState((){
//                      newvalue=value;
//                    });
//
//                  },
//                ),
//                floating: true,
//leading: null,
////                pinned: false,
////                expandedHeight: 150.0,
//                forceElevated: innerBoxIsScrolled,
//                bottom: new TabBar(
//                  tabs: pages.keys
//                      .map((Pageno page) => new Tab(text: page.page))
//                      .toList(),
//                ),
//              ),
//            ];
//          },
//          body: new TabBarView(
//            children: <Widget>[
//              new Container(
//                child: new Scaffold(
////                    appBar: new AppBar(
////                      title: searchBar.build(context),
////
////                    ),
//                  body: personcontainer(newvalue)
//                ),
//              ),
//              new Container(
//                  child:new PersonSearch(newvalue: newvalue1),
//
//                ) ,
//
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
