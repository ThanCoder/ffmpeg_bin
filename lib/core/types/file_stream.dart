import '../utils.dart';

enum StreamCodecType {
  audio,
  video,
  unknown;

  static StreamCodecType fromVal(String val) =>
      values.firstWhere((e) => e.name == val, orElse: () => .unknown);
}

class FileStream {
  final Map<String, dynamic> _map;
  final StreamCodecType codecType;
  const new(this._map, this.codecType);

  /// source map
  Map<String, dynamic> get sourceMap => _map;
  int get index => .parse(_map['index']);
  String get codecName => _map['codec_name'];
  String get codecLongName => _map['codec_long_name'];
  // String get codecType => _map['codec_type'];
  String get codecTagString => _map['codec_tag_string'];
  int get channels => _map.getIntOr('channels', -1);
  int get durationTs => _map.getIntOr('duration_ts', 0);
  double get duration => _map.getDoubleOr('duration', 0);
  int get bitRate => _map.getIntOr('bit_rate', -1);
  int get nbFrames => _map.getIntOr('nb_frames', -1);
  int get sampleRate => _map.getIntOr('sample_rate', -1);
  int get width => _map.getIntOr('width', 0);
  int get height => _map.getIntOr('height', 0);

  String? get sampleAspectRatio => _map['sample_aspect_ratio'];
  String? get displayAspectRatio => _map['display_aspect_ratio'];
  String? get pixFmt => _map['pix_fmt'];
  String? get rRrameRate => _map['r_frame_rate'];
  String? get avgFrameRate => _map['avg_frame_rate'];
  String? get timeBase => _map['time_base'];
}

/*
"streams": [
  {
      "index": 0,
      "codec_name": "aac",
      "codec_long_name": "unknown",
      "profile": "1",
      "codec_type": "audio",
      "codec_tag_string": "mp4a",
      "codec_tag": "0x6134706d",
      "mime_codec_string": "mp4a.40.2",
      "sample_fmt": "fltp",
      "sample_rate": "48000",
      "channels": 2,
      "channel_layout": "stereo",
      "bits_per_sample": 0,
      "initial_padding": 688,
      "id": "0x1",
      "r_frame_rate": "0/0",
      "avg_frame_rate": "0/0",
      "time_base": "1/48000",
      "start_pts": 0,
      "start_time": "0.000000",
      "duration_ts": 15329376,
      "duration": "319.362000",
      "bit_rate": "306418",
      "nb_frames": "14971",
      "extradata_size": 5,
*/
/*
      "disposition": {
          "default": 1,
          "dub": 0,
          "original": 0,
          "comment": 0,
          "lyrics": 0,
          "karaoke": 0,
          "forced": 0,
          "hearing_impaired": 0,
          "visual_impaired": 0,
          "clean_effects": 0,
          "attached_pic": 0,
          "timed_thumbnails": 0,
          "non_diegetic": 0,
          "captions": 0,
          "descriptions": 0,
          "metadata": 0,
          "dependent": 0,
          "still_image": 0,
          "multilayer": 0
      },
      "tags": {
          "language": "eng",
          "handler_name": "SoundHandler"
      }
  },
*/
/*
  {
      "index": 1,
      "codec_name": "png",
      "codec_long_name": "unknown",
      "codec_type": "video",
      "codec_tag_string": "[0][0][0][0]",
      "codec_tag": "0x0000",
      "width": 0,
      "height": 0,
      "has_b_frames": 0,
      "level": -99,
      "id": "0x0",
      "r_frame_rate": "90000/1",
      "avg_frame_rate": "0/0",
      "time_base": "1/90000",
      "start_pts": 0,
      "start_time": "0.000000",
      "duration_ts": 28742580,
      "duration": "319.362000",
*/
/*
      "disposition": {
          "default": 0,
          "dub": 0,
          "original": 0,
          "comment": 0,
          "lyrics": 0,
          "karaoke": 0,
          "forced": 0,
          "hearing_impaired": 0,
          "visual_impaired": 0,
          "clean_effects": 0,
          "attached_pic": 1,
          "timed_thumbnails": 0,
          "non_diegetic": 0,
          "captions": 0,
          "descriptions": 0,
          "metadata": 0,
          "dependent": 0,
          "still_image": 0,
          "multilayer": 0
      }
  }
 */
