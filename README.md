# Swen - news, reversed.

A clean, monochrome news app. Available on Web, macOS, iOS, and Android.

Download for macOS: [Swen.dmg](https://github.com/THEJOHNCALEB/swen/releases/download/SWEN/Swen.dmg)

## Features

- **Splash Screen** — Minimalist "Swen" intro animation
- **Top Headlines** — Browse latest news from multiple categories
- **Category Browsing** — Tech, Sports, Business, Health, Entertainment, Science
- **Keyword Search** — Find articles by search terms
- **Offline Support** — 24-hour article caching with Hive
- **Bookmarks** — Save articles for later reading
- **In-App Browser** — Read full articles with WebView
- **Skeleton Loaders** — Smooth loading states with shimmer effects
- **Animations** — Staggered list animations and custom page transitions
- **Share** — Share articles via native share sheet

## Setup

### Prerequisites

- Flutter SDK 3.0.0 or higher
- NewsAPI key (free tier: 100 requests/day)

### Installation

1. **Get dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Configure API key**
   
   Create a `.env` file in the project root:
   ```
   API_KEY=your_newsapi_key_here
   ```
   
   Get your free API key at [newsapi.org](https://newsapi.org/).

4. **Run**
   ```bash
   flutter run
   ```

**Note:** Fonts (DM Sans, DM Mono) should already be in `assets/fonts/`. If missing, download from [Google Fonts](https://fonts.google.com/).

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── app.dart                            # GoRouter + theme setup
├── app/
│   ├── adaptive_shell.dart             # Responsive navigation shell
│   ├── app_menu.dart                   # macOS PlatformMenuBar
│   └── swen_shortcuts.dart             # Keyboard shortcuts
├── core/
│   ├── constants/                      # Colors, text styles, strings
│   ├── models/                         # Article, ApiResponse
│   ├── services/                       # NewsAPI, Cache, Connectivity
│   ├── errors/                         # Custom exceptions
│   ├── utils/                          # Date formatter, responsive, platform
│   └── routing/                        # GoRouter configuration
├── features/
│   ├── splash/                         # Splash screen
│   ├── feed/                           # Home feed screen
│   ├── categories/                     # Category browsing
│   ├── search/                         # Article search
│   ├── article_detail/                 # WebView article reader
│   └── bookmarks/                      # Saved articles
└── providers/                          # Riverpod providers
```

### Endpoints Used

- `/top-headlines` — Category-based news
- `/everything` — Keyword search

## Caching Strategy

- **Cache duration:** 24 hours
- **Storage:** Hive local database
- **Bookmarks:** Persistent across sessions
- **Offline mode:** Shows cached articles when offline

## Platform Adaptations

- **Mobile (<600px):** Bottom navigation, touch gestures, single-column layout
- **Tablet (600–1024px):** NavigationRail, 2-column article grid
- **Desktop (>1024px):** Sidebar navigation (220px), 2-column feed, app menu bar, keyboard shortcuts, right-click context menus, mouse hover states, resizable window (min 800×560)

## Keyboard Shortcuts (Desktop / Web)

| Shortcut | Action |
|---|---|
| `Cmd/Ctrl + 1` | Go to Feed |
| `Cmd/Ctrl + 2` | Go to Categories |
| `Cmd/Ctrl + 3` | Go to Search |
| `Cmd/Ctrl + 4` | Go to Saved |
| `Cmd/Ctrl + R` | Refresh Feed |
| `Cmd/Ctrl + F` | Focus Search |
| `Escape` | Go back / clear search |
| `?` | Show shortcuts overlay |

## Building for Release

### Web

```bash
flutter build web --release
# Deploy build/web/ to Vercel or Netlify
```

### macOS

```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/Swen.app
# Package as .dmg: hdiutil create -volname Swen -srcfolder Swen.app -format UDZO Swen.dmg
```

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Customization

- **Categories:** `lib/core/constants/categories.dart`
- **Cache duration:** `lib/core/services/cache_service.dart` (default: 24h)
- **Colors:** `lib/core/constants/app_colors.dart`
- **Typography:** `lib/core/constants/app_text_styles.dart`

## License

This project is created for educational purposes (HNG Stage 4).

## Credits

- **News Data:** [NewsAPI](https://newsapi.org/)
- **Fonts:** DM Sans & DM Mono by Google Fonts
