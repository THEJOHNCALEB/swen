# Swen - news, reversed.

A clean, monochrome news app.

**Web:** [swen.thejohncaleb.com](https://swen.thejohncaleb.com)  
**macOS:** [Download Swen.dmg](https://github.com/thejohncaleb/swen/releases/latest/download/Swen.dmg)

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

## Tech Stack

| Layer | Package | Purpose |
|-------|---------|---------|
| State Management | `flutter_riverpod` | App-wide state |
| HTTP Client | `dio` | API calls + interceptors |
| Local Cache | `hive` + `hive_flutter` | Offline cache + bookmarks |
| In-App Browser | `webview_flutter` | Article detail view |
| Images | `cached_network_image` | Image caching |
| Skeleton Loader | `shimmer` | Loading states |
| Animations | `flutter_animate` | UI animations |
| Navigation | `go_router` | Typed routing |
| Connectivity | `connectivity_plus` | Online/offline detection |
| Share | `share_plus` | Share articles |
| Date Formatting | `intl` | Publication dates |
| Secure Storage | `flutter_secure_storage` | API key storage |
| Environment | `flutter_dotenv` | .env configuration |

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
├── core/
│   ├── constants/                      # Colors, text styles, strings
│   ├── models/                         # Article, ApiResponse
│   ├── services/                       # NewsAPI, Cache, Connectivity
│   ├── errors/                         # Custom exceptions
│   ├── utils/                          # Date formatter, helpers
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


## Customization

- **Categories:** `lib/core/constants/categories.dart`
- **Cache duration:** `lib/core/services/cache_service.dart` (default: 24h)
- **Colors:** `lib/core/constants/app_colors.dart`
- **Typography:** `lib/core/constants/app_text_styles.dart`

## Platform Support

| Platform | Status | Notes |
|---|---|---|
| Android | ✅ | Full feature support |
| iOS | ✅ | Full feature support |
| Web | ✅ | [swen.thejohncaleb.com](https://swen.thejohncaleb.com) |
| macOS | ✅ | [Download Swen.dmg](https://github.com/thejohncaleb/swen/releases/latest/download/Swen.dmg) |
| Windows | ✅ | Download: [Google Drive link] |
| Linux | ✅ | Download: [Google Drive link] |

## Platform Adaptations

- **Mobile (<600px):** Bottom navigation, touch gestures, single-column layout
- **Tablet (600–1024px):** NavigationRail, 2-column article grid
- **Desktop (>1024px):** Sidebar navigation (220px), 2-column feed, app menu bar, keyboard shortcuts, right-click context menus, mouse hover states, resizable window (min 800×560)

## Keyboard Shortcuts (Desktop / Web)

| Shortcut | Action |
|---|---|
| Cmd/Ctrl + 1 | Go to Feed |
| Cmd/Ctrl + 2 | Go to Categories |
| Cmd/Ctrl + 3 | Go to Search |
| Cmd/Ctrl + 4 | Go to Saved |
| Cmd/Ctrl + R | Refresh Feed |
| Cmd/Ctrl + F | Focus Search |
| Escape | Go back / clear search |
| ? | Show shortcuts overlay |

## Web Deployment
Live URL: [swen.thejohncaleb.com](https://swen.thejohncaleb.com)

## Desktop Downloads
- macOS (.dmg): [Download Swen.dmg](https://github.com/thejohncaleb/swen/releases/latest/download/Swen.dmg) (21 MB, Apple Silicon / Intel)
- Windows (.exe): [Google Drive link]
- Linux (.AppImage): [Google Drive link]

## Web Build

```bash
flutter build web --release --web-renderer canvaskit
# Deploy the build/web/ folder to Vercel or Netlify
```

## Desktop Builds

### macOS

```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/Swen.app
# Package as .dmg using create-dmg or Xcode archive
```

### Windows

```bash
flutter build windows --release
# Output: build/windows/runner/Release/
# Package as .exe installer using Inno Setup or MSIX
```

### Linux

```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/
# Package as .AppImage using appimagetool
```

## Building for Release

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Notes

- **Minimum SDK:** Android 21 / iOS 14
- **API Key Security:** Stored in `flutter_secure_storage`, never committed to git
- **Font Licensing:** DM Sans and DM Mono are open source (OFL)

## License

This project is created for educational purposes (HNG Stage 4).

## Credits

- **News Data:** [NewsAPI](https://newsapi.org/)
- **Fonts:** DM Sans & DM Mono by Google Fonts
