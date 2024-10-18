// import 'package:flutter/material.dart';
//
//
// class MoodIcons
// {
//   final String ?title;
//   final Color ?color;
//   final double? rotation;
//   final IconData ?icon;
//   const MoodIcons({  this.title,  this.icon,  this.color,  this.rotation});
//
//     IconData ?getMoodIcon(title)
//   {
//     return _moodIconsList[_moodIconsList.indexWhere((mood)=>mood.title==title)].icon;
//   }
//   Color ?getMoodColor(color)
//   {
//     return _moodIconsList[_moodIconsList.indexWhere((mood)=>mood.color==color)].color;
//   }
//   double? getMoodRotation(rotation)
//   {
//     return _moodIconsList[_moodIconsList.indexWhere((mood)=>mood.rotation==rotation)].rotation;
//   }
//   List<MoodIcons> getMoodList()
//   {
//     return _moodIconsList;
//   }
// }
// const  List<MoodIcons> _moodIconsList= <MoodIcons>[
//   const MoodIcons(title: 'Very Satisfied', color: Colors.amber, rotation: 0.4,
//       icon: Icons.sentiment_very_satisfied),
//   const MoodIcons(title: 'Satisfied', color: Colors.green, rotation: 0.2, icon:
//   Icons.sentiment_satisfied),
//   const MoodIcons(title: 'Neutral', color: Colors.grey, rotation: 0.0, icon: Icons.
//   sentiment_neutral),
//   const MoodIcons(title: 'Dissatisfied', color: Colors.cyan, rotation: -0.2, icon:
//   Icons.sentiment_dissatisfied),
//   const MoodIcons(title: 'Very Dissatisfied', color: Colors.red, rotation: -0.4,
//       icon: Icons.sentiment_very_dissatisfied),
// ];

import 'package:flutter/material.dart';

class MoodIcons {
  final String? title;
  final Color? color;
  final double? rotation;
  final IconData? icon;

  const MoodIcons({this.title, this.icon, this.color, this.rotation});

  // Get icon by title
  IconData? getIconByTitle(String title) {
    int index = _moodIconsList.indexWhere((mood) => mood.title == title);
    return index != -1 ? _moodIconsList[index].icon : null;
  }

  // Get color by title
  Color? getColorByTitle(String title) {
    int index = _moodIconsList.indexWhere((mood) => mood.title == title);
    return index != -1 ? _moodIconsList[index].color : null;
  }

  // Get rotation by title
  double? getRotationByTitle(String title) {
    int index = _moodIconsList.indexWhere((mood) => mood.title == title);
    return index != -1 ? _moodIconsList[index].rotation : null;
  }

  // Return the entire list of moods
  List<MoodIcons> getMoodList() {
    return _moodIconsList;
  }
}

// List of mood icons
const List<MoodIcons> _moodIconsList = <MoodIcons>[
  MoodIcons(
      title: 'Very Satisfied',
      color: Colors.amber,
      rotation: 0.4,
      icon: Icons.sentiment_very_satisfied),
  MoodIcons(
      title: 'Satisfied',
      color: Colors.green,
      rotation: 0.2,
      icon: Icons.sentiment_satisfied),
  MoodIcons(
      title: 'Neutral',
      color: Colors.grey,
      rotation: 0.0,
      icon: Icons.sentiment_neutral),
  MoodIcons(
      title: 'Dissatisfied',
      color: Colors.cyan,
      rotation: -0.2,
      icon: Icons.sentiment_dissatisfied),
  MoodIcons(
      title: 'Very Dissatisfied',
      color: Colors.red,
      rotation: -0.4,
      icon: Icons.sentiment_very_dissatisfied),
];
