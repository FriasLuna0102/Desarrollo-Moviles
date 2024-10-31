import 'package:flutter/material.dart';


class PokemonColors {
  static const Map<String, Color> typeColors = {
    'normal': Color(0xFF616161),
    'fire': Colors.orange,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.yellow,
    'ice': Colors.cyan,
    'fighting': Color(0xFFC62828),
    'poison': Colors.purple,
    'ground': Colors.brown,
    'flying': Color(0xFF5C6BC0),
    'psychic': Colors.pink,
    'bug': Colors.lightGreen,
    'rock': Color(0xFFBCAAA4),
    'ghost': Colors.deepPurple,
    'dark': Color(0xFF424242),
    'dragon': Colors.indigo,
    'steel': Colors.blueGrey,
    'fairy': Colors.pinkAccent,
  };

  static Color getTypeColor(String type) {
    return typeColors[type] ?? Colors.grey;
  }
}
