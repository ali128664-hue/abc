# InstaPro Downloader

A professional Android application for downloading Instagram media (Reels, Videos, Photos, Stories, Profile Pictures) built with Flutter.

## 🚀 Setup & Build Instructions

### 1. Initialize Flutter Project
Since the `flutter create` command could not be run automatically, you must generate the platform-specific code (Android/iOS) manually.

Run this command in the project root:
```bash
flutter create . --org com.instapro.downloader --project-name instapro_downloader
```

### 2. Configure Android Permissions
Open `android/app/src/main/AndroidManifest.xml` and add the following permissions inside the `<manifest>` tag, above the `<application>` tag:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

Also, add `android:requestLegacyExternalStorage="true"` to the `<application>` tag if targeting Android 10.

### 3. Add Assets
Ensure the `assets/images/` folder exists and contains an app icon if you want to set one.
An icon has been generated as `instapro_icon.png`. You can use it with `flutter_launcher_icons` package or manually replace `android/app/src/main/res/mipmap-*`.

### 4. Build APK
To build the release APK:
```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## ✨ Features
- **Download Everything**: Reels, Videos, Images, Carousels.
- **Profile Downloader**: Download HD profile pictures.
- **Login Support**: Sign in via WebView to download content from private accounts you follow.
- **Gallery Save**: Automatically saves to device gallery.
- **History**: Keep track of your downloads.
- **Theme**: Light and Dark mode support.

## 🛠 Dependencies
- `provider`: State management
- `dio`: Networking
- `webview_flutter`: Login mechanism
- `permission_handler`: Permissions
- `gallery_saver_plus`: Media saving

## ⚠️ Disclaimer
This app is for educational purposes only. Respect Instagram's terms of service and do not download content without permission.
