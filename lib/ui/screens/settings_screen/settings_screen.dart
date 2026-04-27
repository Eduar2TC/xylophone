import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:xylophone/core/l10n/arb_output/generated/app_localizations.dart';
import 'package:xylophone/providers/locale_provider.dart';
import 'package:xylophone/providers/notes_provider.dart';
import 'package:xylophone/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = AppLocalizations.of(context)!;
    final notesProvider = Provider.of<NotesProvider>(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          locale.settings,
          style: theme.textTheme.titleLarge?.copyWith(
            fontFamily: 'MetronicProBold',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            locale.appearance,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_6, color: theme.iconTheme.color),
            title: Text(
              locale.theme,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              themeProvider.currentTheme.toString().split('.').last,
              style: theme.textTheme.bodyMedium,
            ),
            trailing: DropdownButton<AppTheme>(
              value: themeProvider.currentTheme,
              dropdownColor: theme.dialogTheme.backgroundColor,
              style: theme.textTheme.bodyLarge,
              items: AppTheme.values.map((themeValue) {
                return DropdownMenuItem(
                  value: themeValue,
                  child: Text(themeValue.toString().split('.').last),
                );
              }).toList(),
              onChanged: (newTheme) {
                if (newTheme != null) themeProvider.setTheme(newTheme);
              },
            ),
          ),
          Text(
            locale.notes_colors,
            style: theme.textTheme.bodyMedium,
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
                              child: Theme(
                                data: theme.copyWith(
                                  textTheme: theme.textTheme.copyWith(
                                    titleMedium: theme.textTheme.bodyLarge,
                                  ),
                                  iconTheme: theme.iconTheme.copyWith(
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                  canvasColor: theme.dialogTheme.backgroundColor,
                                ),
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: (color) {
                                    pickerColor = color;
                                  },
                                  enableAlpha: false,
                                  pickerAreaHeightPercent: 0.8,
                                ),
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
                          color: theme.iconTheme.color ?? Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          note.name,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
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
                          color: theme.iconTheme.color ?? Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.refresh,
                          color: theme.iconTheme.color,
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
          Divider(color: theme.dividerColor),
          Text(
            locale.functionality,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                leading: Icon(Icons.music_note, color: theme.iconTheme.color),
                title: Text(
                  locale.sound,
                  style: theme.textTheme.bodyLarge,
                ),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeThumbColor: theme.colorScheme.primary,
                ),
              ),
              ListTile(
                leading: Icon(Icons.vibration, color: theme.iconTheme.color),
                title: Text(
                  locale.vibration,
                  style: theme.textTheme.bodyLarge,
                ),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeThumbColor: theme.colorScheme.primary,
                ),
              ),
              ListTile(
                leading: Icon(Icons.animation, color: theme.iconTheme.color),
                title: Text(
                  locale.note_label_animation,
                  style: theme.textTheme.bodyLarge,
                ),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeThumbColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          Divider(color: theme.dividerColor),
          Text(
            locale.other,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: Icon(Icons.language, color: theme.iconTheme.color),
            title: Text(
              locale.language,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              localeProvider.locale.languageCode == 'en' ? locale.english : locale.spanish,
              style: theme.textTheme.bodyMedium,
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
                                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Theme.of(context).colorScheme.primary;
                                  }
                                  return Theme.of(context).unselectedWidgetColor;
                                }),
                                title: Text(
                                  locale.english,
                                  style: theme.textTheme.bodyLarge,
                                ),
                                value: const Locale('en'),
                              ),
                              RadioListTile<Locale>(
                                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Theme.of(context).colorScheme.primary;
                                  }
                                  return Theme.of(context).unselectedWidgetColor;
                                }),
                                title: Text(
                                  locale.spanish,
                                  style: theme.textTheme.bodyLarge,
                                ),
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
            leading: Icon(Icons.info, color: theme.iconTheme.color),
            title: Text(
              locale.about,
              style: theme.textTheme.bodyLarge,
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Xylophone',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.music_note, size: 40),
                children: [
                  Text("About Xylophone", style: theme.textTheme.bodyLarge),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
