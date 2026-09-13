# HumeTV for Android TV

Personal preview of the Plezy-based client, with bundled Google Fonts Inter and Lucide icons, cinematic backdrops, artwork cards and D-pad navigation.

Target: TCL 65S434-CA (Android TV). The universal APK includes both armeabi-v7a and arm64-v8a, since a 64-bit TV processor may run 32-bit Android. Minimum Android version is 7.1 (API 25). Playback still uses Plezy's existing engines and server connections.

## Install

1. Download HumeTV-Android-TV.apk from the latest successful HumeTV Android TV build under this repository's Actions tab.
2. Transfer the APK to your TV using a USB drive and open it in a file manager. Allow that file manager to install unknown apps when Android asks.
3. Install HumeTV. Open it from your TV's apps and follow Plezy's existing Plex sign-in flow.
4. Use the remote's arrows to browse, OK to open an item, and Back to return. Left from the first card opens navigation. Existing playback controls remain available.

Package ID: com.myplexscripts.humetv. This installs alongside Plezy without replacing it. Google Play does not install or update this personal build.

## Build and signing

The workflow pins Flutter 3.47.1 to commit 6655482ec06e547f90abf8ae7590466f4415978d and resolves pubspec.lock. It produces a release-optimised APK with personal-preview signing. Its preview key is cached in GitHub Actions. Cache eviction can change that key, requiring reinstalling the preview (which clears local settings). For durable distribution, supply your own private Android keystore using android/key.properties. Never commit signing keys or passwords.

Local build, with Flutter 3.47.1 and the Android SDK installed:

    flutter pub get --enforce-lockfile --no-example
    flutter test test/widgets/humetv_skin_test.dart
    flutter build apk --release --target-platform android-arm,android-arm64

For a locally signed personal preview, set HUMETV_PREVIEW_SIGNING=1 before the build. Without it, configure android/key.properties to sign the release.

The upstream Kotlin namespace is retained to preserve native bindings; app IDs and content-provider authorities are isolated. Automatic update checks are disabled in the preview build. Upstream licence and credits remain in the repository.

Actual remote responsiveness, HDR, audio passthrough and server playback must be verified on the physical TV. Compilation and widget checks cannot prove hardware playback compatibility.
