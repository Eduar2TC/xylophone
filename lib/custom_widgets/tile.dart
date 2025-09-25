import 'package:flutter/material.dart';
import 'package:xylophone/custom_widgets/animate_tile.dart';
import 'package:xylophone/custom_widgets/button.dart';

class Tile extends StatelessWidget {
  final String name;
  final int sound;
  final Color color;
  final EdgeInsets? padding;
  const Tile({
    super.key,
    required this.name,
    required this.sound,
    required this.color,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AnimateTile(
      padding: padding,
      tile: Button(color: color, sound: sound, name: name),
    );
  }
}
