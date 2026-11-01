import 'dart:io';

import 'package:android_native_path/android_native_path.dart';
import 'package:ffmpeg_bin/core/ffmpeg_b.dart';
import 'package:ffmpeg_bin/core/ffprobe_b.dart';
import 'package:ffmpeg_bin/core/keys.dart';
import 'package:ffmpeg_bin/core/result_t.dart';
import 'package:ffmpeg_bin/core/utils.dart';

class FFmpegBin {
  static final FFmpegBin instance = FFmpegBin._();
  FFmpegBin._();
  factory FFmpegBin() => instance;

  late String _ffmpegLib;
  late String _ffprobeLib;

  /// ffmpeg binary path
  String get ffmpegLib => _ffmpegLib;

  /// ffprobe binary path
  String get ffprobeLib => _ffprobeLib;

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

  /// kill process
  Result<bool, String> killPid(
    int pid, [
    ProcessSignal signal = ProcessSignal.sigterm,
  ]) {
    try {
      final p = Process.killPid(pid, signal);
      return Ok(p);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
