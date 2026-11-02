import 'dart:async';
import 'dart:convert';

import 'package:ffmpeg_bin/core/result_t.dart';

import 'package:ffmpeg_bin/core/i_binary.dart';

class FFprobeB extends IBinary {
  const new(super.libPath);

  ///
  ///
  ///```bash
  /// ffprobe -v error \
  /// -select_streams v \
  /// -show_entries stream=index,codec_name,width,height:stream_disposition=attached_pic \
  /// -of json \
  /// input.mp3
  /// ```
  Future<Result<String, String>> getCoverArtInfoString(String path) async {
    final p = await run([
      '-v',
      'error',
      '-select_streams',
      'v',
      '-show_entries',
      'stream=index,codec_name,width,height:stream_disposition=attached_pic',
      '-of',
      'json',
      path,
    ]);

    return p.fold(
      onOk: (val) {
        final err = val.stderr.toString();
        if (err.isNotEmpty) {
          return Ok(err);
        }
        return Ok(val.stdout.toString());
      },
    );
  }

  ///get file info
  ///
  ///```bash
  ///ffprobe -v quiet \
  /// -print_format json \
  /// -show_format \
  /// -show_streams \
  /// "video.mp4"
  /// ```
  Future<Result<Map<String, dynamic>, String>> getInfoMap(
    String path, {
    bool showStreams = true,
  }) async {
    final res = await getInfoString(path, showStreams: showStreams);
    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        try {
          final map = jsonDecode(val);
          return Ok(map);
        } catch (e) {
          return Err(e.toString());
        }
      },
    );
  }

  ///get file info
  ///
  ///```bash
  ///ffprobe -v quiet \
  /// -print_format json \
  /// -show_format \
  /// -show_streams \
  /// "video.mp4"
  /// ```
  Future<Result<String, String>> getInfoString(
    String path, {
    bool showStreams = true,
  }) async {
    final res = await run([
      '-v',
      'quiet',
      '-print_format',
      'json',
      '-show_format',
      if (showStreams) '-show_streams',
      path,
    ]);
    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        if (val.stderr.toString().isNotEmpty) {
          return Ok(val.stderr.toString());
        }
        return Ok(val.stdout.toString());
      },
    );
  }
}
