import 'package:flutter/material.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/note_button.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/padding_wrapper.dart';

class NoteButtonWrapper extends StatelessWidget {
  final String name;
  final int sound;
  final Color color;
  final EdgeInsets? padding;
  const NoteButtonWrapper({
    super.key,
    required this.name,
    required this.sound,
    required this.color,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
      padding: padding,
      tile: NoteButton(color: color, sound: sound, name: name),
    );
  }
}
