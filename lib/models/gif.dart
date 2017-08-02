//import 'dart:typed_data';
//import 'package:flutter/material.dart';
//
//import 'package:flutter_animated/animated_gif.dart';
//import 'package:http/http.dart' as http;
//
//
//class Gif extends StatefulWidget {
//  Gif({Key key,this.url}) : super(key: key);
//
//  static const String routeName = "/GalleryPage";
//  final String url;
//
//
////   static const String postRef = snapshot.key;
//
//
//  @override
//  GifState createState() => new GifState();
//}
//
//class GifState extends State<Gif> {
//
//  Uint8List finalUrl;
//
//  @override
//  Widget build(BuildContext context) {
//    return new AnimatedGif.memory(finalUrl);
//  }
//
//  onGifLoad() async {
//    final Uint8List imgBytes = await http.readBytes(widget.url);
//    setState((){
//      finalUrl = imgBytes;
//    });
//
//  }
//
//
//  @override
//   initState() {
//     super.initState();
//     onGifLoad();
//   }
//
//
//
//
//}
