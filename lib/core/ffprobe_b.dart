import 'dart:io';

import 'package:ffmpeg_bin/core/result_t.dart';

class FFprobeB {
  final String _libPath;
  const new(this._libPath);

  Future<Result<String, String>> version() async {
    try {
      final p = await Process.run(_libPath, ['-version']);
      if (p.exitCode > 0) {
        return Err(p.stderr);
      }
      return Ok(p.stdout);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
