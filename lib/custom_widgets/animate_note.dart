import 'package:flutter/material.dart';

class AnimateNote extends StatefulWidget {
  final Widget? tile;
  final EdgeInsets? padding;
  final bool visible;
  final double height;
  final double width;
  const AnimateNote({
    super.key,
    this.tile,
    this.padding,
    this.visible = true,
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
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: widget.visible ? widget.width : 0,
      height: widget.visible ? widget.height : 0,
      padding: widget.padding ?? EdgeInsets.zero,
      child: widget.visible ? widget.tile : null,
    );
  }
}
