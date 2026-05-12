# Xylophone App

A cross-platform Flutter application that simulates a xylophone instrument with interactive and animated notes.

## Features

- **Animated Notes:** Each note animates visually when tapped, including shake and scale effects.
- **Sound Playback:** High-quality sound for each xylophone note, with support for rapid and overlapping playback.
- **Provider Architecture:** State management is handled using the Provider package for scalability and clean code.
- **Dynamic Note Management:** Users can add or remove notes dynamically, with smooth entry/exit animations.
- **Auto-play Songs:** The app can simulate taps to automatically play popular melodies (e.g., "Twinkle Twinkle Little Star", "La Cucaracha").
- **Day/Night Themes:** Easily switch between light and dark (and custom) themes using a dedicated ThemeProvider.
- **Responsive Design:** Adapts to different screen sizes and orientations.
- **Full Immersive Mode:** Runs in true fullscreen on Android, hiding navigation and status bars.
- **Custom Widgets:** Modular and reusable widgets for notes, buttons, and animations.
- **Extensible:** Easily add new features, notes, or themes thanks to a clean architecture.

## Architecture

- **Provider State Management:** All app state (notes, theme, etc.) is managed via Providers for separation of concerns.
- **Models:** Strongly-typed models (e.g., `NoteData`) for notes and other entities.
- **Screens & Widgets:** Organized into folders for screens, widgets, providers, models, and helpers.
- **Animations:** Uses Flutter’s animation framework and third-party packages for interactive effects.
- **Sound Engine:** Efficient sound playback using the audioplayers package.

## Getting Started

1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Launch the app on your preferred device or emulator.

## Demo

https://github.com/user-attachments/assets/0a9b4094-917f-4889-98a0-62864ce17520

## Project Structure

```
lib/
├── app/                          # App entry and configuration
├── core/
│   ├── constants/               # App constants and themes
│   ├── helpers/                 # Utilities (sound, preferences, etc.)
│   ├── l10n/                    # Localization (i18n)
│   └── models/                  # Data models (NoteData)
├── providers/                    # State management (Provider pattern)
│   ├── notes_provider.dart
│   ├── theme_provider.dart
│   ├── locale_provider.dart
│   └── animation_settings_provider.dart
└── ui/
    └── screens/                 # UI screens and custom widgets
        ├── xylophone_screen/
        └── settings_screen/
```

## Key Features Explained

### 🎵 Dynamic Note Management
- Add or remove notes dynamically
- Colors are persisted across sessions
- **Bug Fixed:** Colors are now correctly restored when re-adding deleted notes

### 🎨 Customization
- Change note colors via color picker
- Toggle animations (labels, particles, vibration)
- Switch between day/night themes
- Multi-language support (English, Spanish)

### ⚡ Performance
- Smooth animations using Flutter's animation framework
- Efficient sound playback with overlapping note support
- Optimized rendering with Provider state management

## Technologies Used

- **Flutter** - Cross-platform UI framework
- **Provider** - State management
- **AudioPlayers** - Sound playback
- **SharedPreferences** - Local persistence
- **flutter_colorpicker** - Color selection UI
- **flutter_shake_animated** - Shake animations
- **Flutter Localization** - i18n support

## Installation & Setup

### Prerequisites
- Flutter SDK (2.19.1 or higher)
- Dart SDK

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd xylophone
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Recent Fixes

- ✅ **Color Persistence on Re-add:** Fixed issue where note colors were lost when deleting and re-adding notes. Colors are now properly restored from local storage.

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the MIT License.
