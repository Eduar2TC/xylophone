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

![Xylophone Demo](demo/demo.gif)

---

