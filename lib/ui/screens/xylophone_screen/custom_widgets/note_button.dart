import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:provider/provider.dart';
import 'package:xylophone/core/helpers/sound.dart';
import 'package:xylophone/providers/animation_settings_provider.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/widget_effects/animated_note_label.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/widget_effects/sparks.dart';

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
  AnimationController? _shakeController;

  @override
  void dispose() {
    _shakeController = null;
    super.dispose();
  }

  ///return global offset position
  Offset _getGlobalOffset(TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.localToGlobal(details.localPosition);
  }

  void _showFloatingLabel(TapDownDetails details) {
    if (!mounted) return;
    final Offset globalOffset = _getGlobalOffset(details);
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => AnimatedNoteLabel(
        startPosition: globalOffset,
        label: widget.name,
        onComplete: () => overlayEntry.remove(),
      ),
    );
    overlay.insert(overlayEntry);
  }

  // Show sparks at the tap position (convert local to global coords)
  void _showSparks(TapDownDetails details) {
    if (!mounted) return;
    final Offset globalOffset = _getGlobalOffset(details);
    showSparksOverlay(
      context,
      globalOffset,
      color: widget.color,
      count: 12,
      duration: const Duration(milliseconds: 700),
      maxDistance: 90.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final animationSettings = Provider.of<AnimationSettingsProvider>(context);

    Widget buttonContent = GestureDetector(
      onTapDown: (details) {
        if (!mounted) return;

        final animationSettings =
            Provider.of<AnimationSettingsProvider>(context, listen: false);

        Sound.playSound(widget.sound);

        if (animationSettings.vibrationAnimationEnabled && mounted) {
          final controller = _shakeController;
          if (controller != null) {
            controller.forward(from: 0);
          }
        }

        // Vibración si está habilitada
        if (animationSettings.vibrationAnimationEnabled && mounted) {
          HapticFeedback.mediumImpact();
        }

        // Mostrar etiqueta si está habilitada
        if (animationSettings.labelAnimationEnabled) {
          _showFloatingLabel(details);
        }

        // Mostrar partículas si están habilitadas
        if (animationSettings.particlesEnabled) {
          _showSparks(details);
        }
      },
      child: TextButton(
        style: TextButton.styleFrom(
          elevation: 10,
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: null, // handled by GestureDetector
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
    );

    // Envolver en ShakeWidget solo si la vibración está habilitada
    if (animationSettings.vibrationAnimationEnabled) {
      return ShakeWidget(
        key: ValueKey('${widget.name}_${widget.sound}'),
        autoPlay: false,
        enableWebMouseHover: false,
        shakeConstant: ShakeLittleConstant1(),
        duration: const Duration(seconds: 3),
        onController: (controller) {
          if (!mounted) return;
          _shakeController = controller;
        },
        child: buttonContent,
      );
    }

    _shakeController = null;
    return buttonContent;
  }
}
