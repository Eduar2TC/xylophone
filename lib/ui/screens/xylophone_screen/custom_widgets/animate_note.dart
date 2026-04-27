import 'package:flutter/material.dart';

class AnimateNote extends StatefulWidget {
  final Widget? tile;
  final EdgeInsets? padding;
  final double height;
  final double width;
  const AnimateNote({
    super.key,
    this.tile,
    this.padding,
    this.height = 60,
    this.width = double.infinity,
  });

  @override
  State<AnimateNote> createState() => _AnimateNoteState();
}

class _AnimateNoteState extends State<AnimateNote> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      child: widget.tile,
    );
  }
}
