import 'package:flutter/material.dart';
import 'package:xylophone/core/models/note_data.dart';

/// Agrupa una nota con sus controladores de animación.
class NoteEntry {
  final NoteData note;

  /// Para items iniciales: el master controller compartido.
  /// Para items en runtime: un controller propio.
  final AnimationController enterCtrl;

  /// Solo existe mientras la nota está saliendo.
  AnimationController? exitCtrl;

  /// true = usa el stagger del master. false = entra desde la derecha.
  final bool isInitial;

  /// Posición en el stagger (solo relevante si isInitial == true).
  final int staggerIndex;
  final int staggerTotal;

  NoteEntry({
    required this.note,
    required this.enterCtrl,
    this.exitCtrl,
    this.isInitial = false,
    this.staggerIndex = 0,
    this.staggerTotal = 1,
  });

  /// Devuelve la Animation de entrada lista para usar en transiciones.
  /// Necesita el masterCtrl para construir el Interval del stagger.
  Animation<double> enterAnimation(AnimationController masterCtrl) {
    if (isInitial) {
      final band = 1.0 / staggerTotal;
      final start = (staggerIndex * band).clamp(0.0, 1.0);
      final end = ((staggerIndex + 1) * band).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: masterCtrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    }
    return CurvedAnimation(parent: enterCtrl, curve: Curves.easeOut);
  }

  /// Animation de salida, o null si el item no está saliendo.
  Animation<double>? get exitAnim => exitCtrl;

  /// Libera solo los controllers que le pertenecen.
  /// El masterCtrl NO se libera aquí — lo hace el State.
  void dispose() {
    if (!isInitial) enterCtrl.dispose();
    exitCtrl?.dispose();
  }
}
