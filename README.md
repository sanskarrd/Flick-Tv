# FLICK TV - Flutter OTT Streaming App

A Netflix-style OTT (Over-the-Top) streaming application built with Flutter, featuring a modern dark UI, video streaming capabilities, and smooth user experience.

## 🎬 Features

### 📱 Home Screen (Netflix-style UI)
- **Hero Banner**: Featured content with gradient overlay and clickable interaction
- **Multiple Categories**: "Trending Now", "Top Picks for You", "Watch It Again"
- **Horizontal Carousels**: Smooth scrolling movie thumbnails
- **Dark Cinematic Theme**: Netflix-inspired color palette

### 🎥 Video Player (Reels-style)
- **Full-screen Playback**: Immersive video experience
- **Vertical Navigation**: Swipe up/down to navigate between videos
- **Auto-play**: Videos start automatically when opened
- **Custom Controls**: Netflix-red themed progress bar and controls
- **Responsive UI**: Proper control positioning without overlaps

### 🎨 UI/UX Design
- **Loading Screen**: Branded FLIX TV splash with animated progress
- **Dark Theme**: Deep black backgrounds with red accents
- **Material Design**: Modern typography and component styling
- **Smooth Animations**: Fluid transitions and interactions

### 🏗 Architecture
- **BLoC Pattern**: State management using flutter_bloc
- **Repository Pattern**: Clean data layer separation
- **API Integration**: Real-time data fetching with fallback support
- **Error Handling**: Graceful error states and recovery

## 🛠 Technical Stack

- **Framework**: Flutter 3.29.3
- **Language**: Dart
- **State Management**: BLoC (flutter_bloc)
- **Video Player**: Chewie + video_player
- **HTTP Client**: http package
- **Architecture**: Clean Architecture with Repository pattern

## 📋 Prerequisites

Before running this project, ensure you have:

- **Flutter SDK**: Version 3.0.0 or higher
- **Dart SDK**: Version 2.18.0 or higher
- **Android Studio**: Latest version with Android SDK
- **Java**: JDK 17 or higher
- **Git**: For version control

### Development Environment Setup

1. **Install Flutter**:
   ```bash
   # Download Flutter SDK from https://flutter.dev/docs/get-started/install
   # Add Flutter to your PATH
   export PATH="$PATH:`pwd`/flutter/bin"
   ```

2. **Verify Installation**:
   ```bash
   flutter doctor
   ```

3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/flicktv.git
cd flicktv
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the Application

#### For Android Device/Emulator:
```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Run on specific device
flutter run -d DEVICE_ID
```

#### For iOS Simulator (macOS only):
```bash
flutter run -d ios
```

#### For Web:
```bash
flutter run -d chrome
```

### 4. Build for Production

#### Android APK:
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

#### Android App Bundle (for Play Store):
```bash
flutter build appbundle --release
```

## 📁 Project Structure

```
lib/
├── bloc/                   # BLoC state management
│   ├── video_bloc.dart
│   ├── video_event.dart
│   └── video_state.dart
├── models/                 # Data models
│   └── video_item.dart
├── pages/                  # Screen widgets
│   ├── home_page.dart
│   ├── player_page.dart
│   └── splash_page.dart
├── repository/             # Data layer
│   └── local_repository.dart
├── services/               # API services
│   └── api_service.dart
├── util/                   # Utilities
│   └── strings.dart
├── widgets/                # Reusable widgets
│   ├── horizontal_carousel.dart
│   └── loading_screen.dart
└── main.dart              # App entry point
```

## 🎨 Design System

### Color Palette
- **Primary Background**: `#0E0E10` (Deep Black)
- **Card Background**: `#1A1A1C` (Charcoal Gray)
- **Accent Color**: `#E50914` (Netflix Red)
- **Text Primary**: `#FFFFFF` (White)
- **Text Secondary**: `#B3B3B3` (Light Gray)

### Typography
- **App Logo**: 24-28px, Bold, Netflix Red
- **Hero Title**: 28-32px, Bold, White
- **Section Titles**: 20px, Semi-Bold, White
- **Body Text**: 16px, Regular, Light Gray

## 📱 App Flow

1. **Splash Screen**: Branded loading with progress animation
2. **Data Loading**: Fetches movie catalog from API
3. **Home Screen**: Netflix-style interface with carousels
4. **Video Selection**: Tap any thumbnail to open player
5. **Video Player**: Full-screen playback with vertical navigation

## 🔧 Configuration

### Android Configuration
- **Minimum SDK**: API 21 (Android 5.0)
- **Target SDK**: API 34 (Android 14)
- **Compile SDK**: API 34

### Dependencies
```yaml
dependencies:
  flutter_bloc: ^8.1.3      # State management
  equatable: ^2.0.3         # Value equality
  video_player: ^2.5.1      # Video playback
  chewie: ^1.4.2            # Video player UI
  http: ^1.1.0              # HTTP client
```

## 🐛 Troubleshooting

### Common Issues

1. **Gradle Build Errors**:
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

2. **Video Playback Issues**:
   - Ensure device has internet connection
   - Check video URL accessibility
   - Verify video format compatibility

3. **Image Loading Failures**:
   - Images use Picsum service for reliable loading
   - Fallback UI shows movie icon and title

### Performance Tips
- Use `flutter run --release` for better performance
- Enable R8 code shrinking for smaller APK size
- Test on physical devices for accurate performance

## 📄 License

This project is created for educational purposes as part of a Flutter development assignment.

## 🤝 Contributing

This is an assignment project, but feedback and suggestions are welcome!

## 📞 Support

For any issues or questions regarding this project, please create an issue in the GitHub repository.

---

**Built with ❤️ using Flutter**