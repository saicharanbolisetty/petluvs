import 'package:flutter/material.dart';

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget title,
    Color color,
    Widget firebase,
    TickerProvider vsync,
  }) : _icon = icon,
  _firebase = firebase,
        _color = color,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: title,
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _icon;
  final Color _color;
  final Widget _firebase;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new FractionalOffsetTween(
          begin: const FractionalOffset(0.0, 0.02), // Small offset from the top.
          end: FractionalOffset.topLeft,
        ).animate(_animation),
        child: _firebase,
      ),
    );
  }
}

//class CustomIcon extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final IconThemeData iconTheme = IconTheme.of(context);
//    return new Container(
//      margin: const EdgeInsets.all(4.0),
//      width: iconTheme.size - 8.0,
//      height: iconTheme.size - 8.0,
//      color: iconTheme.color,
//    );
//  }
//}