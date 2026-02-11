import 'package:flutter/material.dart';

class CardColor {
  final int id;

  CardColor(this.id);

  /// Couleur quand la carte est face cachée
  Color get hidden => Colors.grey.shade400;

  /// Couleur quand la carte est retournée
  Color get revealed => _colorsById[id];

  /// Couleur quand la carte est matchée
  Color get matched => revealed.withAlpha(102);

  static const List<Color> _colorsById = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.brown,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.deepPurple,
    Colors.yellow,
    Colors.lightGreen,
  ];
}