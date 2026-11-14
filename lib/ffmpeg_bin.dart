import 'dart:io';

import 'package:ffmpeg_bin/core/binary/ffmpeg_b.dart';
import 'package:ffmpeg_bin/core/binary/ffprobe_b.dart';
import 'package:ffmpeg_bin/core/keys.dart';
import 'package:ffmpeg_bin/core/result_t.dart';
import 'package:ffmpeg_bin/core/utils.dart';
import 'package:android_native_path/android_native_path.dart';

class FFmpegBin {
  static final FFmpegBin instance = FFmpegBin._();
  FFmpegBin._();
  factory FFmpegBin() => instance;

  late String _ffmpegLib;
  late String _ffprobeLib;

  /// ffmpeg binary
  late final FFmpegB ffmpeg = .new(_ffmpegLib);

  /// ffprobe binary
  late final FFprobeB ffprobe = .new(_ffprobeLib);

  ///supported platforms
  bool get isSupported =>
      Platform.isLinux || Platform.isWindows || Platform.isAndroid;

  bool _showDebug = true;

  ///
  /// make sure -> `WidgetsFlutterBinding.ensureInitialized();`
  ///
  Future<void> initialize({bool showDebugLog = true}) async {
    _showDebug = showDebugLog;
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

  /// show debug log
  void showDebugLog(String msg) {
    if (!_showDebug) return;
    // ignore: avoid_print
    print(msg);
  }
}
