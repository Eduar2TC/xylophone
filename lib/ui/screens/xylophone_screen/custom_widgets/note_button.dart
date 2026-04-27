import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:xylophone/core/helpers/sound.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/animated_note_label.dart'; // <--- nuevo import

class NoteButton extends StatefulWidget {
  final Color color;
  final int sound;
  final String name;

  const NoteButton({
    super.key,
    required this.color,
    required this.sound,
    required this.name,
  });

  @override
  State<NoteButton> createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton> {
  AnimationController? animationController;

  void _showFloatingLabel(TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset globalPosition = box.localToGlobal(details.localPosition);

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => AnimatedNoteLabel(
        startPosition: globalPosition,
        label: widget.name,
        onComplete: () => overlayEntry.remove(),
      ),
    );
    overlay.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      key: ValueKey('${widget.name}_${widget.sound}'),
      autoPlay: false,
      enableWebMouseHover: false,
      shakeConstant: ShakeLittleConstant1(),
      duration: const Duration(seconds: 3),
      onController: (controller) {
        animationController = controller;
      },
      child: GestureDetector(
        onTapDown: (details) {
          Sound.playSound(widget.sound);
          animationController?.reset();
          animationController?.forward();
          _showFloatingLabel(details);
        },
        child: TextButton(
          style: TextButton.styleFrom(
            elevation: 10,
            backgroundColor: widget.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: null, // Deshabilitado, usamos GestureDetector
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    width: 25,
                    height: 25,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
