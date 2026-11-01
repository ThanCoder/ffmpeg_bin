import 'package:ffmpeg_bin/core/result_t.dart';
import 'package:ffmpeg_bin/ffmpeg_bin.dart';
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
  final pkg = FFmpegBin.instance;
  void onTestFFmpeg() async {
    final res = await pkg.ffmpeg.version();
    switch (res) {
      case Ok(value: final val):
        resultText = val;
      case Err(value: final err):
        resultText = 'Error: $err';
    }
    setState(() {});
  }
  void onTestProb() async {
    final res = await pkg.ffprobe.version();
    switch (res) {
      case Ok(value: final val):
        resultText = val;
      case Err(value: final err):
        resultText = 'Error: $err';
    }
    setState(() {});
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
          onPressed: onTestFFmpeg),
        FloatingActionButton(
          heroTag: '2',
          onPressed: onTestProb),
      ],),
      body: SingleChildScrollView(
        child: Container(padding: const .all(10), child: Text(resultText)),
      ),
    );
  }
}
