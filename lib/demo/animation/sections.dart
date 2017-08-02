// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Raw data for the animation demo.

import 'package:flutter/material.dart';
import 'package:petluvs/views/myposts.dart';
import 'package:petluvs/views/profilepage.dart';
import 'package:petluvs/views/gallery.dart';
import 'package:petluvs/views/checkin.dart';




const Color _mariner = const Color(0xFF3B5F8F);
const Color _mediumPurple = const Color(0xFF8266D4);
const Color _tomato = const Color(0xFFF95B57);
const Color _mySin = const Color(0xFFF3A646);
const Color _deepCerise = const Color(0xFFD93F9B);










class SectionDetail {
   SectionDetail({ this.title, this.subtitle, this.imageAsset , this.add});
  final String title;
  final String subtitle;
  final String imageAsset;
  final Widget add;
}

class Section {
  Section({ this.title, this.backgroundAsset, this.leftColor, this.rightColor, this.details });
  final String title;
  final String backgroundAsset;
  final Color leftColor;
  final Color rightColor;
  final List<SectionDetail> details;

  @override
  bool operator==(Object other) {
    if (other is! Section)
      return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}

// TODO(hansmuller): replace the SectionDetail images and text. Get rid of
// the const vars like _eyeglassesDetail and insert a variety of titles and
// image SectionDetails in the allSections list.

 SectionDetail _status = new SectionDetail(
   add: new Container(child:new IconButton(icon: new Icon(Icons.pets), onPressed: (){}),),


 );

 SectionDetail _gallery = new SectionDetail(
   add: new GalleryPage(),


 );

 SectionDetail _chechkin = new SectionDetail(
//   add: new CheckInPage(),


 );


final List<Section> allSections = <Section>[
  new Section(
    title: 'STATUS',
    leftColor: _mediumPurple,
    rightColor: _mariner,
    backgroundAsset: 'graphics/petloves.png',
    details: <SectionDetail>[
      _status,
    ],
  ),
  new Section(
    title: 'GALLERY',
    leftColor: _tomato,
    rightColor: _mediumPurple,
    backgroundAsset: 'graphics/petloves.png',
    details:  <SectionDetail>[
      _gallery,
    ],
  ),
  new Section(
    title: 'PLAY DATE',
    leftColor: _mySin,
    rightColor: _tomato,
    backgroundAsset: 'graphics/petloves.png',
    details:  <SectionDetail>[


    ],
  ),
  new Section(
    title: 'CHECKIN',
    leftColor: Colors.white,
    rightColor: _tomato,
    backgroundAsset: 'graphics/petloves.png',
    details: <SectionDetail>[
  _chechkin,
    ],
  ),
];
