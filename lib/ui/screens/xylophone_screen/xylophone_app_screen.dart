import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xylophone/core/models/note_data.dart';
import 'package:xylophone/providers/notes_provider.dart';
import 'package:xylophone/ui/screens/settings_screen/settings_screen.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/animated_note_item.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/circle_button.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/note_button_wrapper.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/note_entry.dart';

class XylophoneAppScreen extends StatefulWidget {
  const XylophoneAppScreen({Key? key}) : super(key: key);

  @override
  State<XylophoneAppScreen> createState() => _XylophoneAppScreenState();
}

class _XylophoneAppScreenState extends State<XylophoneAppScreen> with TickerProviderStateMixin {
  // Una sola lista reemplaza: _visibleNotes, _initialIds, _enterControllers, _exitControllers
  final List<NoteEntry> _entries = [];

  // Controller único para el stagger inicial
  late final AnimationController _masterCtrl;

  late NotesProvider _notesProvider;
  bool _initialized = false;

  // ─── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _setupInitialEntries();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _notesProvider.removeListener(_onNotesChanged);
    _masterCtrl.dispose();
    for (final e in _entries) {
      e.dispose();
    }
    super.dispose();
  }

  // ─── Setup inicial ───────────────────────────────────────────────────────────

  void _setupInitialEntries() {
    _notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final notes = List<NoteData>.from(_notesProvider.notes);

    for (var i = 0; i < notes.length; i++) {
      _entries.add(NoteEntry(
        note: notes[i],
        enterCtrl: _masterCtrl,
        isInitial: true,
        staggerIndex: i,
        staggerTotal: notes.length,
      ));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _masterCtrl.forward();
    });

    _notesProvider.addListener(_onNotesChanged);
  }

  // ─── Sincronización con el provider ─────────────────────────────────────────

  void _onNotesChanged() {
    final newNotes = List<NoteData>.from(_notesProvider.notes);

    // Entradas: notas que el provider tiene pero no están en _entries
    for (var i = 0; i < newNotes.length; i++) {
      final note = newNotes[i];
      final alreadyVisible = _entries.any((e) => e.note.sound == note.sound);
      if (!alreadyVisible) {
        final ctrl = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 350),
        );
        final entry = NoteEntry(note: note, enterCtrl: ctrl);
        final insertIndex = i.clamp(0, _entries.length);

        setState(() => _entries.insert(insertIndex, entry));

        Future<void>.delayed(const Duration(milliseconds: 20), () {
          if (mounted) ctrl.forward();
        });
      }
    }

    // Salidas: entries que ya no están en el provider
    for (final entry in List<NoteEntry>.from(_entries)) {
      final stillExists = newNotes.any((n) => n.sound == entry.note.sound);
      if (!stillExists && entry.exitCtrl == null) {
        final exitCtrl = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        );
        setState(() => entry.exitCtrl = exitCtrl);

        exitCtrl.forward().whenComplete(() {
          setState(() => _entries.remove(entry));
          entry.dispose();
        });
      }
    }
  }

  void _removeNote() {
    if (_notesProvider.notes.isNotEmpty) {
      _notesProvider.removeNote(_notesProvider.notes.length - 1);
    }
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final width = MediaQuery.of(context).size.width;
    const double basePadding = 55.0;

    final notesList = List<Widget>.generate(_entries.length, (i) {
      final entry = _entries[i];
      final visibleCount = _entries.isNotEmpty ? _entries.length : 1;
      final rawPadding = width * (basePadding - (basePadding / visibleCount * i) - basePadding / visibleCount) / 100;
      final paddingRight = math.max(0.0, rawPadding);

      return Expanded(
        flex: 1,
        child: AnimatedNoteItem(
          key: ValueKey(entry.note.sound),
          enter: entry.enterAnimation(_masterCtrl),
          exit: entry.exitAnim,
          isInitial: entry.isInitial,
          child: NoteButtonWrapper(
            key: ValueKey('note_${entry.note.sound}_$i'),
            name: entry.note.name,
            sound: entry.note.sound,
            color: entry.note.color,
            padding: EdgeInsets.fromLTRB(0, 0, paddingRight, 10),
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // ── Riel izquierdo ───────────────────────────────────────
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 60,
                            color: Theme.of(context).appBarTheme.backgroundColor,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: CircleButton(
                                      iconData: Icons.remove,
                                      onPress: _removeNote,
                                    ),
                                  ),
                                  const Text(
                                    'XIPHONE',
                                    style: TextStyle(
                                      fontFamily: 'MetronicProBold',
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: CircleButton(
                                      iconData: Icons.add,
                                      onPress: notesProvider.addNote,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Área de notas ────────────────────────────────────────
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _entries.isNotEmpty
                            ? notesList
                            : [
                                Expanded(
                                  child: Center(
                                    child: TweenAnimationBuilder<double>(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.decelerate,
                                      tween: Tween<double>(begin: 0.0, end: 1.0),
                                      builder: (context, value, _) => Transform.translate(
                                        offset: Offset(-width / 2 + value * width / 2, 0),
                                        child: AnimatedOpacity(
                                          duration: const Duration(milliseconds: 500),
                                          opacity: value,
                                          child: const Text(
                                            'No notes available',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontFamily: 'MetronicProBold',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ],
                ),

                // ── Botón settings ───────────────────────────────────────────
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    highlightColor: Colors.lightBlueAccent.withAlpha(50),
                    icon: const Icon(Icons.settings, color: Colors.white, size: 52),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
