import 'package:ffmpeg_bin/core/result_t.dart';

import 'package:ffmpeg_bin/core/i_binary.dart';

class FFprobeB extends IBinary {
  const new(super.libPath);

  Future<Result<String, String>> checkInfo(String path) async {
    final res = await run([path]);
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
