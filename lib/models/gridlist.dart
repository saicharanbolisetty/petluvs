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

//final uauth = FirebaseAuth.instance;

enum GridDemoTileStyle {

  oneLine

}

const double _kMinFlingVelocity = 800.0;
typedef void BannerTapCallback(DataSnapshot snapshot);



class GridPhotoViewer extends StatefulWidget {
  const GridPhotoViewer({ Key key, this.snapshot }) : super(key: key);

  final DataSnapshot snapshot;

  @override
  _GridPhotoViewerState createState() => new _GridPhotoViewerState();
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return new FittedBox(
      fit: BoxFit.scaleDown,
      alignment: FractionalOffset.centerLeft,
      child: new Text(text),
    );
  }
}

class _GridPhotoViewerState extends State<GridPhotoViewer> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = MediaQuery.of(context).size;
    final Offset minOffset = new Offset(size.width, size.height) * (1.0 - _scale);
    return new Offset(offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity)
      return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(
        begin: _offset,
        end: _clampOffset(_offset + direction * distance)
    ).animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: new ClipRect(
        child: new Transform(
          transform: new Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
          child: new Image.network(widget.snapshot.value['author']['profile_picture'], fit: BoxFit.cover),
        ),
      ),
    );
  }
}






@override
class GridList extends StatelessWidget {
  GridList({this.snapshot,this.animation});

  final Animation animation;


  final DataSnapshot snapshot;
  final GridDemoTileStyle tileStyle=GridDemoTileStyle.oneLine;
//  final BannerTapCallback onBannerTap; // User taps on the photo's header or footer.

  void showPhoto(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
                title: new Text(snapshot.value['author']['full_name'])
            ),
            body: new SizedBox.expand(
              child: new Hero(
                tag: snapshot.value['author']['profile_picture'],
                child: new GridPhotoViewer(snapshot: snapshot),
              ),
            ),
          );
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = new GestureDetector(
        onTap: () { showPhoto(context); },
        child: new Hero(
            key: new Key(snapshot.value['author']['profile_picture']),
            tag: snapshot.value['author']['profile_picture'],
            child: new Image.network(snapshot.value['author']['profile_picture'], fit: BoxFit.cover)
        )
    );

//    final IconData icon = photo.isFavorite ? Icons.star : Icons.star_border;

    switch(tileStyle) {

      case GridDemoTileStyle.oneLine:
        return new GridTile(
          header: new GestureDetector(
//            onTap: () { onBannerTap(snapshot); },
            child: new GridTileBar(
              title: new _GridTitleText(snapshot.value['author']['full_name']),
              backgroundColor: Colors.black45,
//              leading: new Icon(
//                Icons.pets,
//                color: Colors.white,
//              ),
            ),
          ),
          child: image,
        );

    }
    assert(tileStyle != null);
    return null;
  }
}