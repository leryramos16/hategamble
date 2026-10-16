# Chitah: release

© 2026 LRY. All rights reserved.

## Isang beses lang (bago ang unang release)

1. Gumawa ng signing key (pirma ng app). Ikaw ang pipili ng password:

```bash
"/c/Program Files/Android/Android Studio/jbr/bin/keytool.exe" -genkey -v -keystore C:/Users/leryr/chitah-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Kopyahin ang `android/key.properties.example` bilang `android/key.properties` at ilagay ang password mo.
3. I-backup ang `C:\Users\leryr\chitah-upload.jks` at ang password nito (USB at private na Google Drive).
   Kapag nawala ito, hindi mo na maa-update ang app sa mga phone na may naka-install na.

## Bawat release

1. Taasan ang version sa `pubspec.yaml` (hal. `1.0.0+1` → `1.0.1+2`), at ang `_appVersion` sa `lib/features/settings/settings_screen.dart`.
2. I-build:

```bash
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/symbols
```

3. Ang ia-upload sa Google Drive: `build\app\outputs\flutter-apk\app-arm64-v8a-release.apk`
   (gumagana sa halos lahat ng phone ngayon).
