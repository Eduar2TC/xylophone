import 'package:flutter/material.dart';

/// Renderiza las transiciones de entrada y salida de una nota.
/// Solo recibe Animations listas — nunca crea controllers.
class AnimatedNoteItem extends StatelessWidget {
  final Animation<double> enter;
  final Animation<double>? exit;
  final bool isInitial;
  final Widget child;

  const AnimatedNoteItem({
    required this.enter,
    required this.child,
    this.exit,
    this.isInitial = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Salida: baja y desaparece
    if (exit != null) {
      return FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(parent: exit!, curve: Curves.easeIn),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0, 1.2),
          ).animate(CurvedAnimation(parent: exit!, curve: Curves.easeIn)),
          child: child,
        ),
      );
    }

    // Entrada inicial (stagger): slide suave desde la izquierda
    if (isInitial) {
      return FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(enter),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(enter),
          child: ScaleTransition(
            scale: Tween(begin: 0.96, end: 1.0).animate(
              CurvedAnimation(parent: enter, curve: Curves.elasticOut),
            ),
            child: child,
          ),
        ),
      );
    }

    // Entrada en runtime: entra desde la derecha
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(enter),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: enter, curve: Curves.easeOut)),
        child: ScaleTransition(
          scale: Tween(begin: 0.98, end: 1.0).animate(
            CurvedAnimation(parent: enter, curve: Curves.easeOutBack),
          ),
          child: child,
        ),
      ),
    );
  }
}
