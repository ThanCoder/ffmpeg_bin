// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:ffmpeg_bin/ffmpeg_bin.dart';
import 'package:material_ui/material_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FFmpegBin.instance.initialize();

  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String resultText = '';
  Uint8List? bytes;
  final pkg = FFmpegBin.instance;

  void onTestFFmpeg() async {
    final res = await pkg.ffmpeg.getVersion();
    res.onResult(
      onErr: (err) => setState(() {
        resultText = 'Error: $err';
      }),
      onOk: (val) => setState(() {
        resultText = val;
      }),
    );
  }

  void onTestProb() async {
    final res = await pkg.ffprobe.getVersion();
    res.onResult(
      onErr: (err) => setState(() {
        resultText = 'Error: $err';
      }),
      onOk: (val) => setState(() {
        resultText = val;
      }),
    );
  }

  String get aPath => '/home/thancoder/Music/test1.mp3';
  String get vPath => '/home/thancoder/Videos/Jennifer Body.mp4';

  void onCheckAudioInfo() async {
    final res = await pkg.ffprobe.getFileInfo(aPath);
    res.onResult(
      onErr: (err) => setState(() {
        resultText = 'Error: $err';
      }),
      onOk: (val) => setState(() {
        resultText = val.text;
      }),
    );
    return;
    // final res = await pkg.ffprobe.getCoverArtInfoString(aPath);
    // switch (res) {
    //   case Ok(value: final val):
    //     resultText = val;
    //   case Err(value: final err):
    //     resultText = 'Error: $err';
    // }
    // setState(() {});
  }

  void setAudioTags() async {
    await pkg.ffmpeg.audio.writeCoverArt(
      aPath,
      '/home/thancoder/Music/test1.mp3',
      coverArtPath: '/home/thancoder/Pictures/ChatGPT Image Sep 19, 2026, 02_12_12 PM.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Packages')),
      floatingActionButton: Column(
        mainAxisSize: .min,
        spacing: 10,
        children: [
          FloatingActionButton(
            heroTag: '1',
            onPressed: onTestFFmpeg,
            child: Text('ffmpeg'),
          ),
          FloatingActionButton(
            heroTag: '2',
            onPressed: onTestProb,
            child: Text('ffprobe'),
          ),
          FloatingActionButton(
            heroTag: '3',
            onPressed: onCheckAudioInfo,
            child: Text('check'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: .all(10),
            sliver: SliverList.list(
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton(
                      onPressed: setAudioTags,
                      child: Text('Set Audio Tag'),
                    ),
                  ],
                ),
                if (bytes != null)
                  Image.memory(
                    bytes!,
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) => Text('Error'),
                  ),
                SelectableText(resultText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
