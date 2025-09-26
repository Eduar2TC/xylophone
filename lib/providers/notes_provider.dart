import 'package:flutter/material.dart';
import 'package:xylophone/core/constants/constants.dart';
import 'package:xylophone/core/models/note_data.dart';

class NotesProvider extends ChangeNotifier {
  List<NoteData> notes = List<NoteData>.from(noteList); //n

  Future<void> removeNote(int index) async {
    if (index < 0 || index >= notes.length) return;
    notes[index].visible = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 150));
    notes.removeAt(index);
    notifyListeners();
  }

  Future<void> addNote() async {
    if (notes.length < noteList.length) {
      final nextNote = noteList[notes.length];
      notes.add(NoteData(
        name: nextNote.name,
        sound: nextNote.sound,
        color: nextNote.color,
        visible: false,
      ));
      notifyListeners();
      await Future.delayed(Duration.zero);
      notes.last.visible = true;
      notifyListeners();
    }
  }

  void resetNotes() {
    notes = List<NoteData>.from(noteList);
    notifyListeners();
  }
}
