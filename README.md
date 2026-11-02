# ffmpeg_bin

### Example

- [x] [Example Usage](#example-usage)
- [x] [Android build.gradle.kts](#android-buildgradlekts)

### Example Usage

- [x] [Example](#example)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FFmpegBin.instance.init();

  runApp(MaterialApp(home: const MyApp()));
}

final pkg = FFmpegBin.instance;

// ffmpeg
await pkg.ffmpeg.run(args);
pkg.ffmpeg.runSync(args);
await pkg.ffmpeg.start(args);

//ffprobe
await pkg.ffprobe.run(args);
pkg.ffprobe.runSync(args);
await pkg.ffprobe.start(args);

final res = await pkg.ffmpeg.getVersion();
switch (res) {
    case Ok(value: final val):
    resultText = val;// version string
    case Err(value: final err):
    resultText = 'Error: $err'; //error
}

 final res = await pkg.ffprobe.getVersion();
switch (res) {
    case Ok(value: final val):
    resultText = val;
    case Err(value: final err):
    resultText = 'Error: $err';
}

```

### Android build.gradle.kts

```kts

// android/app/build.gradle.kts

android {
    // ရှိပြီးသား configuration တွေကို မဖျက်ပါနဲ့။

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}
```
