# MindEase App Structure & Firebase Integration Guide

## 📱 App Architecture

```
mindease/
├── lib/
│   ├── main.dart                      # App entry point with Firebase init
│   ├── firebase_options.dart          # Firebase configuration
│   ├── models/                        # Data models
│   │   ├── affirmation.dart
│   │   ├── journal_entry.dart
│   │   ├── mood_entry.dart
│   │   ├── music_track.dart
│   │   └── user_settings.dart
│   ├── services/                      # Business logic & API calls
│   │   ├── auth_service.dart          # Firebase Authentication (NEW)
│   │   ├── affirmation_service.dart
│   │   ├── journal_service.dart
│   │   ├── mood_service.dart
│   │   └── music_service.dart
│   ├── screens/                       # UI Screens
│   │   ├── login_page.dart            # Login (to update with Firebase)
│   │   ├── signup_page.dart           # Signup (to update with Firebase)
│   │   ├── onboarding_page.dart
│   │   ├── dashboard_page.dart
│   │   ├── home_page.dart
│   │   ├── profile_page.dart
│   │   ├── settings_page.dart
│   │   ├── stats_page.dart
│   │   ├── achievements_page.dart
│   │   ├── forgot_password_page.dart
│   │   └── user_settings_page.dart
│   ├── widgets/                       # Reusable components
│   └── assets/
│       ├── image1.jpg - image13.jpg
│       └── audio/
│           ├── audio1.mp3
│           └── audio2.mp3
├── android/                           # Android native code
├── ios/                               # iOS native code
├── windows/                           # Windows native code
├── web/                               # Web platform files
├── pubspec.yaml                       # Dependencies (updated with Firebase)
└── README.md
```

## 🔐 Firebase Setup Steps

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a new project"
3. Name it "MindEase"
4. Enable Google Analytics (optional)
5. Create project

### Step 2: Register Your App

#### For Web:
1. Click "Web" icon in Firebase Console
2. App nickname: "MindEase Web"
3. Copy the Firebase config
4. Replace values in `lib/firebase_options.dart` (web section)

#### For Android:
1. Click "Android" icon in Firebase Console
2. Package name: `com.mindease.app`
3. SHA-1: Get from `keytool -exportcert -list -v -alias androiddebugkey -keystore ~/.android/keystore.jks`
4. Copy the google-services.json to `android/app/`

#### For iOS:
1. Click "iOS" icon in Firebase Console
2. Bundle ID: `com.mindease.app`
3. Download GoogleService-Info.plist
4. Add to Xcode project under `ios/Runner/`

### Step 3: Enable Firebase Services

In Firebase Console, go to **Build** menu and enable:

#### Authentication:
1. Click "Authentication"
2. Click "Get started"
3. Enable "Email/Password" provider
4. Optional: Enable "Google", "Facebook", "Apple"

#### Firestore Database:
1. Click "Firestore Database"
2. Click "Create database"
3. Start in "Test mode" (for development)
4. Choose region closest to you
5. Create

### Step 4: Set Firestore Rules (for production)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow create: if request.auth.uid != null;
    }
    match /mood_entries/{userId}/{document=**} {
      allow read, write: if request.auth.uid == userId;
    }
    match /journal_entries/{userId}/{document=**} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

## 🔑 Authentication Service Usage

### Sign Up
```dart
final authService = AuthService();
try {
  final user = await authService.signup(
    email: 'user@example.com',
    password: 'password123',
    name: 'John Doe',
  );
  print('User created: ${user?.email}');
} on FirebaseAuthException catch (e) {
  print('Error: ${e.message}');
}
```

### Login
```dart
try {
  final user = await authService.login(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Logged in: ${user?.email}');
} on FirebaseAuthException catch (e) {
  print('Error: ${e.message}');
}
```

### Logout
```dart
await authService.logout();
```

### Check Auth State
```dart
authService.authStateChanges().listen((user) {
  if (user == null) {
    // Navigate to login
  } else {
    // Navigate to dashboard
  }
});
```

## 📝 Update Login & Signup Pages

### Replace login_page.dart login logic:
```dart
final authService = AuthService();

// In login button handler
try {
  await authService.login(
    email: emailController.text,
    password: passwordController.text,
  );
  // Navigate to dashboard
  Navigator.of(context).pushReplacementNamed('/dashboard');
} on FirebaseAuthException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message ?? 'Login failed')),
  );
}
```

### Replace signup_page.dart signup logic:
```dart
final authService = AuthService();

// In signup button handler
try {
  await authService.signup(
    email: emailController.text,
    password: passwordController.text,
    name: nameController.text,
  );
  // Show success message and navigate to login
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Account created successfully!')),
  );
  Navigator.of(context).pop();
} on FirebaseAuthException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message ?? 'Signup failed')),
  );
}
```

## 🗄️ Firestore Database Structure

```
users/
├── {uid}/
│   ├── uid: string
│   ├── email: string
│   ├── name: string
│   ├── createdAt: timestamp
│   ├── currentStreak: number
│   ├── totalMoodEntries: number
│   └── totalAffirmations: number

mood_entries/
├── {uid}/
│   ├── {moodId}/
│   │   ├── mood: string (Great, Good, Okay, Bad)
│   │   ├── intensity: number (1-10)
│   │   ├── note: string
│   │   └── timestamp: timestamp

journal_entries/
├── {uid}/
│   ├── {entryId}/
│   │   ├── title: string
│   │   ├── content: string
│   │   ├── mood: string
│   │   └── timestamp: timestamp
```

## 🚀 Next Steps

1. **Install packages**: `flutter pub get`
2. **Update firebase_options.dart** with your Firebase credentials
3. **Update login_page.dart** to use AuthService
4. **Update signup_page.dart** to use AuthService
5. **Add auth state check** in main.dart for navigation
6. **Test authentication** on web/Android/iOS

## 📦 Dependencies Added

- `firebase_core: ^4.0.0` - Firebase core SDK
- `firebase_auth: ^5.0.0` - Firebase Authentication
- `cloud_firestore: ^5.0.0` - Firestore Database

## ⚠️ Important Notes

- Keep `firebase_options.dart` secure in production
- Use environment variables for API keys
- Test Firestore rules before going live
- Enable Multi-factor authentication for enhanced security
- Set up Firebase App Check for production apps
