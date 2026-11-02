// ignore_for_file: avoid_print

import 'package:ffmpeg_bin/core/result_t.dart';
import 'package:ffmpeg_bin/ffmpeg_bin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FFmpegBin.instance.init();

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
    switch (res) {
      case Ok(value: final val):
        resultText = val;
      case Err(value: final err):
        resultText = 'Error: $err';
    }
    setState(() {});
  }

  void onTestProb() async {
    final res = await pkg.ffprobe.getVersion();
    switch (res) {
      case Ok(value: final val):
        resultText = val;
      case Err(value: final err):
        resultText = 'Error: $err';
    }
    setState(() {});
  }

  String get aPath => '/home/thancoder/Music/test1.mp3';
  String get vPath => '/home/thancoder/Videos/Jennifer Body.mp4';

  void onCheckAudioInfo() async {
    final res = await pkg.ffmpeg.video.saveThumbnail(
      vPath,
      '/home/thancoder/test.png',
    );
    // final bytesRes = await pkg.ffmpeg.video.getThumbnailBytes(vPath);
    switch (res) {
      case Ok(value: final bytes):
        print('success: $bytes');
        // resultText = 'data: ${bytes.length}';
        // this.bytes = bytes;
        break;
      case Err(value: final err):
        resultText = err;
    }
    setState(() {});
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
          FloatingActionButton(heroTag: '1', onPressed: onTestFFmpeg),
          FloatingActionButton(heroTag: '2', onPressed: onTestProb),
          FloatingActionButton(heroTag: '3', onPressed: onCheckAudioInfo),
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
