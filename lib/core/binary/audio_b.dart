import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_bin/core/binary/ffmpeg_b.dart';
import 'package:ffmpeg_bin/core/result_t.dart';

class AudioB {
  final String libPath;
  final FFmpegB _ffmpeg;
  const new(this.libPath, this._ffmpeg);

  ///
  ///```bash
  ///ffmpeg -v error \
  ///   -i input.mp3 \
  ///   -map 0:v:0 \
  ///   -frames:v 1 \
  ///   -f image2pipe \
  ///   -vcodec copy \
  ///   pipe:1
  /// ```
  Future<Result<Uint8List, String>> getCoverArtBytes(String path) async {
    final p = await _ffmpeg.start([
      '-v',
      'error',
      '-i',
      path,
      '-map',
      '0:v:0',
      '-frames:v',
      '1',
      '-f',
      'image2pipe',
      '-vcodec',
      'copy',
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

  /// write tags
  ///
  /// ```bash
  /// ffmpeg -i input.mp3 \
  /// -c copy \
  /// -metadata title="My Song" \
  /// -metadata artist="Than Coder" \
  /// -metadata album="My Album" \
  /// -metadata genre="Pop" \
  /// -metadata date="2026" \
  /// output.mp3
  /// ```
  Future<Result<String, String>> writeTags(
    String path,
    String outpath, {
    required String title,
    required String artist,
    required String album,
    required String genre,
    required int date,
  }) async {
    final p = await _ffmpeg.run([
      '-i',
      path,
      '-c',
      'copy',
      '-metadata',
      'title="$title"',
      '-metadata',
      'artist="$artist"',
      '-metadata',
      'album="$album"',
      '-metadata',
      'genre="$genre"',
      '-metadata',
      'date="$date"',
      outpath,
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

  /// write cover art
  ///
  /// ```bash
  /// ffmpeg -i input.mp3 \
  ///   -i cover.jpg \
  ///   -map 0:a \
  ///   -map 1:v \
  ///   -map_metadata 0 \
  ///   -c:a copy \
  ///   -c:v copy \
  ///   -id3v2_version 3 \
  ///   -metadata:s:v title="Album cover" \
  ///   -metadata:s:v comment="Cover (front)" \
  ///   -disposition:v attached_pic \
  ///   output.mp3
  /// ```
  Future<Result<String, String>> writeCoverArt(
    String path,
    String outpath, {
    required String coverArtPath,
    String coverTitle = 'Album cover',
    String coverComment = 'Cover (front)',
  }) async {
    final p = await _ffmpeg.run([
      '-i',
      path,
      '-i',
      coverArtPath,
      '-map',
      '0:a',
      '-map',
      '1:v',
      '-map_metadata',
      '0',
      '-c:a',
      'copy',
      '-c:v',
      'copy',
      '-id3v2_version',
      '3',
      '-metadata:s:v',
      'title="$coverTitle"',
      '-metadata:s:v',
      'comment="$coverComment"',
      '-disposition:v',
      'attached_pic',
      outpath,
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
}
