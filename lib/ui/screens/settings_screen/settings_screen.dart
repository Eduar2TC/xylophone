import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:xylophone/core/l10n/arb_output/generated/app_localizations.dart';
import 'package:xylophone/providers/locale_provider.dart';
import 'package:xylophone/providers/notes_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = AppLocalizations.of(context)!;
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xff23242a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        title: Text(
          locale.settings,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'MetronicProBold',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            locale.appearance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6, color: Colors.white),
            title: Text(
              locale.theme,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Claro/Oscuro/Sistema',
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () {},
          ),
          // Grupo de colores de las notas
          Text(
            locale.notes_colors,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(notesProvider.notes.length + 1, (index) {
                if (index < notesProvider.notes.length) {
                  final note = notesProvider.notes[index];
                  return GestureDetector(
                    onTap: () {
                      Color pickerColor = note.color;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('${locale.choose_color_for_note} ${note.name}'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: (color) {
                                  pickerColor = color;
                                },
                                enableAlpha: false,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(locale.ok),
                                onPressed: () {
                                  notesProvider.updateNoteColor(index, pickerColor);
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(locale.cancel),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 32,
                      height: 42,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: note.color,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          note.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(locale.reset_colors),
                            content: Text(locale.are_you_sure_you_want_to_reset_the_colors_of_the_notes),
                            actions: [
                              TextButton(
                                child: Text(locale.cancel),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text(locale.ok),
                                onPressed: () {
                                  notesProvider.resetNotes();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.white24),
          Text(
            locale.functionality,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                leading: const Icon(Icons.music_note, color: Colors.white),
                title: Text(
                  locale.sound,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeThumbColor: Colors.blue,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.vibration, color: Colors.white),
                title: Text(
                  locale.vibration,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeThumbColor: Colors.blue,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.animation, color: Colors.white),
                title: Text(
                  locale.animation,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeThumbColor: Colors.blue,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24),
          Text(
            locale.other,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.white),
            title: Text(
              locale.language,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              localeProvider.locale.languageCode == 'en' ? locale.english : locale.spanish,
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(locale.language),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioGroup<Locale>(
                          groupValue: localeProvider.locale,
                          onChanged: (Locale? value) {
                            if (value != null) {
                              localeProvider.setLocale(value);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile<Locale>(
                                title: Text(locale.english),
                                value: const Locale('en'),
                              ),
                              RadioListTile<Locale>(
                                title: Text(locale.spanish),
                                value: const Locale('es'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: Text(
              locale.about,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Xylophone',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.music_note, size: 50),
                children: [
                  const Text("About Xylophone"),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
