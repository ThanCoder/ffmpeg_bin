// ignore_for_file: avoid_print

import 'dart:io';

import 'package:ffmpeg_bin/ffmpeg_bin.dart';
import 'package:path/path.dart' as p;

String getDesktopLibFullPath(String libName) {
  // 1. App binary ရှိနေသည့် file path ကို ယူခြင်း
  final executablePath = Platform.resolvedExecutable;

  // 2. ၎င်း၏ Parent directory (folder) ကို ဖြတ်ယူခြင်း
  final executableDir = File(executablePath).parent.path;

  // 3. lib folder ထဲရှိ libName ရဲ့ absolute path ကို တည်ဆောက်ခြင်း
  // (ဥပမာ - app တည်ရှိရာ folder အောက်မှ lib/libname.so)

  if (Platform.isWindows) {
    return File(p.join(executableDir, libName)).absolute.path;
  }
  final libPath = p.join(executableDir, 'lib', libName);

  return File(libPath).absolute.path;
}

Future<void> makeExecutableAndRun(String filePath) async {
  try {
    // ၁။ chmod +x ပေးခြင်း
    final chmodResult = await Process.run('chmod', ['+x', filePath]);

    if (chmodResult.exitCode != 0) {
      FFmpegBin.instance.showDebugLog(
        'Failed to grant execution permission: ${chmodResult.stderr}',
      );
      return;
    }

    FFmpegBin.instance.showDebugLog(
      'Successfully granted execution permission! - ${filePath.split(Platform.pathSeparator).last}',
    );
  } catch (e) {
    FFmpegBin.instance.showDebugLog('Error: $e');
  }
}

extension DurationX on Duration {
  String toTimeString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(inHours);
    String minutes = twoDigits(inMinutes.remainder(60));
    String seconds = twoDigits(inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}

String formatFileSizeLable(int size) {
  if (size <= 0) return '0 bytes';
  int i = 0;
  final pow = 1024;
  final list = ['bytes', 'KB', 'MB', 'GB', 'TB'];
  double sizeD = size.toDouble();
  while (sizeD > pow && i < (list.length - 1)) {
    sizeD /= pow;
    i++;
  }
  return '${sizeD.toStringAsFixed(2)} ${list[i]}';
}

extension StringX on String {
  String join(String name) {
    return '$this${Platform.pathSeparator}$name';
  }

  String get nameOnly {
    return split(Platform.pathSeparator).last;
  }
}

extension MapX on Map<String, dynamic> {
  String getStringOr(String key, String def) {
    final val = _getOrNull<String>(key);
    return val ?? def;
  }

  int getIntOr(String key, int def) {
    return _getOr<int>(key, def);
  }

  double getDoubleOr(String key, double def) {
    return _getOr<double>(key, def);
  }

  T _getOr<T>(String key, T def) {
    final val = _getOrNull<T>(key);
    return val ?? def;
  }

  T? _getOrNull<T>(String key) {
    final val = this[key];

    if (val is T) {
      return val;
    }

    if (val == null) return null;

    return switch (T) {
      String => val.toString() as T?,
      int =>
        (val is String ? int.tryParse(val) : int.tryParse(val.toString()))
            as T?,
      double =>
        (val is String ? double.tryParse(val) : double.tryParse(val.toString()))
            as T?,
      bool => (val is String ? bool.tryParse(val) : null) as T?,
      _ => null,
    };
  }
}
