//import 'package:flutter/material.dart';
//
//
//class LoadingListView<T> extends StatefulWidget {
//
//  /// Abstraction for loading the data.
//  /// This can be anything: An API-Call,
//  /// loading data from a certain file or database,
//  /// etc. It will deliver a list of objects (of type T)
//  final PageRequest<T> pageRequest;
//
//  /// Used for building Widgets out of
//  /// the fetched data
//  final WidgetAdapter<T> widgetAdapter;
//
//  /// The number of elements requested for each page
//  final int pageSize;
//
//  /// The number of "left over" elements in list which
//  /// will trigger loading the next page
//  final int pageThreshold;
//
//  /// [PageView.reverse]
//  final bool reverse;
//
//
//
//  final Indexer<T> indexer;
//
//  LoadingListView(this.pageRequest, {
//    this.pageSize: 50,
//    this.pageThreshold:10,
//    @required this.widgetAdapter,
//    this.reverse: false,
//    this.indexer
//  });
//
//  @override
//  State<StatefulWidget> createState() {
//    return new _LoadingListViewState();
//  }
//}
//
//class _LoadingListViewState<T> extends State<LoadingListView<T>> {
//
//  /// Contains all fetched elements ready to display!
//  List<T> objects = [];
//
//  @override
//  Widget build(BuildContext context) {
//    ListView listView = new ListView.builder(
//        itemBuilder: itemBuilder,
//        itemCount: objects.length,
//        reverse: widget.reverse
//    );
//
//    return listView;
//  }
//}
//
//Widget itemBuilder(BuildContext context, int index) {
//  return widget.widgetAdapter != null ? widget.widgetAdapter(objects[index])
//      : new Container();
//}
//
//Future loadNext() async {
//  int page = (objects.length / widget.pageSize).floor();
//  List<T> fetched = await widget.pageRequest(page, widget.pageSize);
//
//  if(mounted) {
//    this.setState(() {
//      objects.addAll(fetched);
//    });
//  }
//}