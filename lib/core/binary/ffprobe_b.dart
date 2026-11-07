import 'dart:async';
import 'dart:convert';

import 'package:ffmpeg_bin/core/result_t.dart';

import 'package:ffmpeg_bin/core/binary/i_binary.dart';
import 'package:ffmpeg_bin/core/types/file_info_res.dart';

class FFprobeB extends IBinary {
  const new(super.libPath);

  /// audio,video file info or null
  Future<FileInfoRes?> getFileInfoOrNull(String path) async {
    final res = await getFileInfo(path);
    return switch (res) {
      Ok(value: final val) => val,
      Err() => null,
    };
  }

  /// audio,video file info or null
  FileInfoRes? getFileInfoOrNullSync(String path) {
    final res = getFileInfoSync(path);
    return switch (res) {
      Ok(value: final val) => val,
      Err() => null,
    };
  }

  /// audio,video file info
  Future<Result<FileInfoRes, String>> getFileInfo(String path) async {
    // ffprobe -v quiet -print_format json -show_format -show_streams
    final res = await run([
      '-v',
      'quiet',
      '-print_format',
      'json',
      '-show_format',
      '-show_streams',
      path,
    ]);
    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        final err = val.stderr.toString();
        if (err.isNotEmpty) {
          return Err(err);
        }
        return Ok(.new(val.stdout.toString()));
      },
    );
  }

  /// audio,video file info
  Result<FileInfoRes, String> getFileInfoSync(String path) {
    // ffprobe -v quiet -print_format json -show_format -show_streams
    final res = runSync([
      '-v',
      'quiet',
      '-print_format',
      'json',
      '-show_format',
      '-show_streams',
      path,
    ]);
    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        final err = val.stderr.toString();
        if (err.isNotEmpty) {
          return Err(err);
        }
        return Ok(.new(val.stdout.toString()));
      },
    );
  }

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
      onErr: (err) => Err(err),
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
