import 'package:flutter/material.dart';

class NoteData {
  final String name;
  final int sound;
  final Color color;
  bool visible;

  NoteData({
    required this.name,
    required this.sound,
    required this.color,
    this.visible = true,
  });
}
