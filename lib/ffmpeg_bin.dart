import 'dart:io';

import 'package:android_native_path/android_native_path.dart';
import 'package:ffmpeg_bin/core/ffmpeg_b.dart';
import 'package:ffmpeg_bin/core/ffprobe_b.dart';
import 'package:ffmpeg_bin/core/keys.dart';
import 'package:ffmpeg_bin/core/utils.dart';

class FFmpegBin {
  static final FFmpegBin instance = FFmpegBin._();
  FFmpegBin._();
  factory FFmpegBin() => instance;

  late String _ffmpegLib;
  late String _ffprobeLib;

  ///
  /// make sure -> `WidgetsFlutterBinding.ensureInitialized();`
  ///
  Future<void> init() async {
    if (Platform.isLinux || Platform.isWindows) {
      _ffmpegLib = getDesktopLibFullPath(ffmpegLibName);
      _ffprobeLib = getDesktopLibFullPath(ffprobeLibName);

      await makeExecutableAndRun(_ffmpegLib);
      await makeExecutableAndRun(_ffprobeLib);
      return;
    }
    if (Platform.isAndroid) {
      _ffmpegLib = (await AndroidNativePath.instance.getNativeLib(
        ffmpegLibName,
      ))!;
      _ffprobeLib = (await AndroidNativePath.instance.getNativeLib(
        ffprobeLibName,
      ))!;
      return;
    }

    throw UnsupportedError('Unsupported ${Platform.operatingSystem}!');
  }

  late final FFmpegB ffmpeg = .new(_ffmpegLib);
  late final FFprobeB ffprobe = .new(_ffprobeLib);
}
