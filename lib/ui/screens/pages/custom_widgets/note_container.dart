import 'package:flutter/material.dart';
import 'package:xylophone/ui/screens/pages/custom_widgets/animate_note.dart';
import 'package:xylophone/ui/screens/pages/custom_widgets/note_button.dart';

class NoteContainer extends StatelessWidget {
  final String name;
  final int sound;
  final Color color;
  final EdgeInsets? padding;
  const NoteContainer({
    super.key,
    required this.name,
    required this.sound,
    required this.color,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AnimateNote(
      padding: padding,
      tile: NoteButton(color: color, sound: sound, name: name),
    );
  }
}
