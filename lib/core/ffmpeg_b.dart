import 'package:ffmpeg_bin/core/audio_b.dart';

import 'package:ffmpeg_bin/core/i_binary.dart';
import 'package:ffmpeg_bin/core/video_b.dart';

class FFmpegB extends IBinary {
  new(super.libPath);

  /// audio lib
  late final AudioB audio = .new(libPath, this);
  late final VideoB video = .new(libPath, this);
}
