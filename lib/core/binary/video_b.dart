import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_bin/core/binary/ffmpeg_b.dart';
import 'package:ffmpeg_bin/core/result_t.dart';
import 'package:ffmpeg_bin/core/utils.dart';

class VideoB {
  final String libPath;
  final FFmpegB _ffmpeg;
  const new(this.libPath, this._ffmpeg);

  ///
  ///```bash
  ///ffmpeg -v error \
  /// -ss 1 \
  /// -i input.mp4 \
  /// -frames:v 1 \
  /// -vf scale=320:-2 \
  /// -y \
  /// thumbnail.jpg
  /// ```
  Future<Result<bool, String>> saveThumbnail(
    String path,
    String imagePath, {
    Duration duration = const Duration(seconds: 5),
  }) async {
    final p = await _ffmpeg.run([
      '-v',
      'error',
      '-ss',
      '1',
      '-i',
      path,
      '-frames:v',
      '1',
      '-vf',
      'scale=320:-2',
      '-y',
      imagePath,
    ]);
    return p.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        final err = val.stderr.toString();
        if (err.isNotEmpty) {
          return Err(err);
        }
        if (val.exitCode == 0) {
          return Ok(true);
        }
        return Ok(false);
      },
    );
  }

  ///
  ///```bash
  /// ffmpeg -v error \
  ///   -ss 1 \
  ///   -i input.mp4 \
  ///   -frames:v 1 \
  ///   -vf "scale=320:-2" \
  ///   -f image2pipe \
  ///   -c:v mjpeg \
  ///   pipe:1
  /// ```
  Future<Result<Uint8List, String>> genThumbnailBytes(
    String path, {
    Duration duration = const Duration(seconds: 5),
  }) async {
    final p = await _ffmpeg.start([
      '-v',
      'error',
      '-ss',
      '${duration.inSeconds}',
      '-i',
      path,
      '-frames:v',
      '1',
      '-vf',
      'scale=320:-2',
      '-f',
      'image2pipe',
      '-c:v',
      'mjpeg',
      'pipe:1',
    ]);
    return p.foldAsync(
      onErr: (err) async => Err(err),
      onOk: (val) async {
        try {
          final bytesFut = val.stdout.fold(
            <int>[],
            (prev, ele) => prev..addAll(ele),
          );
          final errFut = val.stderr.transform(SystemEncoding().decoder).join();
          final err = await errFut;

          final bytes = await bytesFut;
          if (bytes.isEmpty) {
            return Err(err.isNotEmpty ? err : 'No video thumbnail found');
          }

          return Ok(.fromList(bytes));
        } catch (e) {
          return Err(e.toString());
        }
      },
    );
  }
}
