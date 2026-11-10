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
res.onResult(
    onErr: (err) => setState(() {
    resultText = 'Error: $err';
    }),
    onOk: (val) => setState(() {
    resultText = val.text;
    }),
);

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
