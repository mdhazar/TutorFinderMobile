## TutorFinder Mobile - Quick Start

### Prerequisites

- Flutter SDK installed
- iOS: Xcode + CocoaPods
- Backend API running locally at `http://localhost:8000` (Django)
- For Backend clone this repo and follow instructions: https://github.com/mdhazar/DjangoProject

### Configure API URL

The app picks host automatically:

- iOS simulator: `http://localhost:8000/api`

If your backend runs elsewhere, update `lib/config/api.dart` → `apiBaseUrl()`

### Install dependencies

```bash
flutter pub get
```

### Run (iOS Simulator)

```bash
open ios/Runner.xcworkspace
# In Xcode, select a simulator and run, or use:
flutter run -d ios
Tested on ios 18.6 iphone 16 pro
```

### Demo Accounts

- Student: `student1` / `DemoStudent!123`
- Tutor: `tutor1` / `DemoTutor!123`
