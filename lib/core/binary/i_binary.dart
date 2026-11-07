import 'dart:io';

import 'package:ffmpeg_bin/core/result_t.dart';

abstract class IBinary {
  final String libPath;
  const new(this.libPath);

  /// get binary version
  Future<Result<String, String>> getVersion() async {
    try {
      final p = await Process.run(libPath, ['-version']);
      final err = p.stderr.toString();
      if (err.isNotEmpty) {
        return Err(err);
      }
      return Ok(p.stdout);
    } catch (e) {
      return Err(e.toString());
    }
  }

  /// run process
  Future<Result<ProcessResult, String>> run(List<String> args) async {
    try {
      final p = await Process.run(libPath, args);
      return Ok(p);
    } catch (e) {
      return Err(e.toString());
    }
  }

  /// start process
  Future<Result<Process, String>> start(List<String> args) async {
    try {
      final p = await Process.start(libPath, args);
      return Ok(p);
    } catch (e) {
      return Err(e.toString());
    }
  }

  /// run sync process
  Result<ProcessResult, String> runSync(List<String> args) {
    try {
      final p = Process.runSync(libPath, args);
      return Ok(p);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
