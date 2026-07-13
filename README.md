# TUNE

**T**UNE's **U**nofficially **N**ot **E**ndorsed — a YouTube Music client built with
Flutter and Material 3 Expressive.

TUNE brings the fluid, tactile motion and bold visual identity of Material 3 Expressive
to YouTube Music — morphing playback controls, spring-based transitions, and a fast,
ad-free listening experience.

> ⚠️ **Status: early development.** Expect rough edges, missing features, and breaking changes.

## Why

YouTube Music doesn't have an official public API or an expressive design system on
mobile. TUNE exists to explore what that could look like — a native-feeling client with
the shape-morphing buttons, spring physics, and expressive motion introduced in Material 3
Expressive, applied to a real, everyday app.

## Features

- 🔍 Search, browse, and play from YouTube Music's catalog
- 🎨 Material 3 Expressive UI — morphing shapes, spring motion, expressive color
- ▶️ Background playback with lock-screen / notification controls
- 📃 Playlists, library, and queue management
- 🌗 Dynamic color theming, light & dark mode

## Tech stack

- **Flutter** — cross-platform UI
- **Material 3 Expressive** — shape morphing (`material_shapes`) and spring motion (`motor`)
- **just_audio** + **audio_service** — playback and background/lock-screen controls
- **flutter_bloc** — state management
- **get_it** — service locator / dependency injection

## Project structure

```
lib/
  common/
    theme/        # ThemeData, spring page physics, expressive tokens
    widgets/       # Shared widgets
    helpers/       # Service locator, misc helpers
    values/        # App-wide constants
  features/
    home/          # Feed, mini-player card
    player/         # Full player page, playback controls
    search/         # Search & browse
    library/       # Playlists, saved music
    auth/           # Sign-in
    menu/           # Settings
  main.dart
```

Each feature is self-contained (`pages/`, `widgets/`, `models/`, `cubits/`) with a barrel
file exporting its public surface — kept isolated so features can be read, tested, and
reworked independently.

## Legal

TUNE is an independent, open-source project. It is **not affiliated with, endorsed by, or
connected to Google or YouTube** — as the name says. It relies on unofficial,
reverse-engineered access to YouTube Music's internal endpoints, which may change or break
without notice, and use of this app may be against YouTube's Terms of Service. Use at your
own risk.

## Contributing

Issues and PRs are welcome once the initial architecture stabilizes. Follow the existing
feature-first structure and keep UI primitives (shapes, motion, sheets) in shared widgets
rather than duplicating them per feature.

## License

MIT
