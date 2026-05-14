import 'package:flutter/material.dart';
import 'package:xylophone/core/constants/notes_constants.dart';
import 'package:xylophone/core/helpers/prefs_helper.dart';
import 'package:xylophone/core/models/note_data.dart';

class NotesProvider extends ChangeNotifier {
  List<NoteData> notes = List<NoteData>.from(noteList);

  NotesProvider() {
    lodadColors();
  }

  Future<void> lodadColors() async {
    for (int i = 0; i < notes.length; i++) {
      final colorValue = (await PrefsHelper.prefs).getInt('note_color_$i');
      if (colorValue != null) {
        notes[i] = NoteData(
          name: notes[i].name,
          sound: notes[i].sound,
          color: Color(colorValue),
        );
      }
    }
    notifyListeners();
  }

  Future<void> removeNote(int index) async {
    if (index < 0 || index >= notes.length) return;
    notifyListeners();
    notes.removeAt(index);
    notifyListeners();
  }

  Future<void> addNote() async {
    if (notes.length < noteList.length) {
      final nextNote = noteList[notes.length];
      final noteIndex = notes.length;
      
      Color noteColor = nextNote.color;
      final colorValue = (await PrefsHelper.prefs).getInt('note_color_$noteIndex');
      if (colorValue != null) {
        noteColor = Color(colorValue);
      }
      
      notes.add(NoteData(
        name: nextNote.name,
        sound: nextNote.sound,
        color: noteColor,
      ));
      notifyListeners();
    }
  }

  Future<void> resetNotes() async {
    notes = List<NoteData>.from(noteList);
    for (int i = 0; i < notes.length; i++) {
      (await PrefsHelper.prefs).setInt('note_color_$i', notes[i].color.toARGB32());
    }
    notifyListeners();
  }

  Future<void> updateNoteColor(int index, Color color) async {
    if (index < 0 || index >= notes.length) return;
    if (index >= 0 && index < notes.length) {
      notes[index] = NoteData(name: notes[index].name, sound: notes[index].sound, color: color);
    }
    (await PrefsHelper.prefs).setInt('note_color_$index', color.toARGB32());
    notifyListeners();
  }
}
