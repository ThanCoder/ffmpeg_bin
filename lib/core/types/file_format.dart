/* {
filename: /home/thancoder/Videos/Jennifer Body.mp4, 
nb_streams: 2, 
nb_programs: 0, 
nb_stream_groups: 0, 
format_name: mov,mp4,m4a,3gp,3g2,mj2, 
start_time: 0.000000, 
duration: 6449.621333, 
size: 1127995081, 
bit_rate: 1399145, 
probe_score: 100, 

tags: {major_brand: isom, minor_version: 512, compatible_brands: isomiso2avc1mp41, encoder: Lavf58.29.100}}

*/


import '../utils.dart';
import 'file_tag.dart';

class FileFormat {
  final Map<String, dynamic> _map;
  const new(this._map);

  /// source map
  Map<String, dynamic> get sourceMap => _map;

  /// file tag
  FileTag? get tagOrNull {
    final map = _map['tags'];
    if (map == null) return null;
    return .new(map);
  }

  /// file tag
  FileTag get tag {
    return tagOrNull!;
  }

  String get filename => _map['filename'];
  int get nbStreams => _map.getIntOr('nb_streams', -1);
  int get nbPrograms => _map.getIntOr('nb_programs', -1);
  int get nbStreamGroups => _map.getIntOr('nb_stream_groups', -1);
  String get formatName => _map['format_name'];
  double get startTime => _map.getDoubleOr('start_time', 0);

  /// seconds
  double get durationSecs => _map.getDoubleOr('duration', 0);
  int get size => _map.getIntOr('size', 0);
  int get bitRate => _map.getIntOr('bit_rate', -1);
  int get probeScore => _map.getIntOr('probe_score', -1);

  /// duration
  Duration get duration => Duration(seconds: durationSecs.toInt());

  /// size lable
  String get sizeLable => formatFileSizeLable(size);
}
