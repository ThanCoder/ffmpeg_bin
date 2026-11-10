# ffmpeg_bin

A Flutter/Dart package that provides a convenient interface for executing **FFmpeg and FFprobe** commands.

Supports asynchronous execution, synchronous execution, and process streaming through a simple API.

- [x] [Initialization](#initialization)
- [x] [Android Configuration](#android-configuration)

## Example Usage

### Initialization

Initialize `FFmpegBin` before running the application.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FFmpegBin.instance.init();

  runApp(MaterialApp(home: const MyApp()));
}
```

### Get Instance

```dart
final pkg = FFmpegBin.instance;
```

### FFmpeg

```dart
// Execute asynchronously
await pkg.ffmpeg.run(args);

// Execute synchronously
pkg.ffmpeg.runSync(args);

// Start a process with streaming output
await pkg.ffmpeg.start(args);
```

### FFprobe

```dart
// Execute asynchronously
await pkg.ffprobe.run(args);

// Execute synchronously
pkg.ffprobe.runSync(args);

// Start a process with streaming output
await pkg.ffprobe.start(args);
```

### Get FFmpeg Version

```dart
final res = await pkg.ffmpeg.getVersion();

res.onResult(
  onErr: (err) => setState(() {
    resultText = 'Error: $err';
  }),
  onOk: (val) => setState(() {
    resultText = val.text;
  }),
);
```

### Get FFprobe Version

```dart
final res = await pkg.ffprobe.getVersion();

res.onResult(
  onErr: (err) => setState(() {
    resultText = 'Error: $err';
  }),
  onOk: (val) => setState(() {
    resultText = val.text;
  }),
);
```

## Android Configuration

For Android, enable legacy JNI library packaging in your `android/app/build.gradle.kts` file.

```kotlin
android {
    // Keep your existing Android configuration.

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}
```

**Important:** Do not remove your existing Android configuration. Only add the `packaging` section if it is not already configured.

## Features

- FFmpeg command execution
- FFprobe command execution
- Asynchronous execution (`run`)
- Synchronous execution (`runSync`)
- Process streaming (`start`)
- FFmpeg version information
- FFprobe version information

## Requirements

- Flutter
- Dart
- Android JNI packaging configuration (Android builds)
