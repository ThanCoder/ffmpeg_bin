/*
"tags": {
  "major_brand": "M4A ",
  "minor_version": "512",
  "compatible_brands": "M4A isomiso2",
  "encoder": "Lavf60.16.100",
  "title": "The Crew - Get Low [GMV]",
  "artist": "KP7 Epic Videos",
  "genre": "Gaming",
  "date": "20150811",
  "comment": "https://www.youtube.com/watch?v=oQ6KD_FTix0",
  "description": "Song: Dillon Francis, DJ Snake - Get Low\nCheck The amazing Pagani Design Watches\nGreat price and great quality :\nhttps://www.paganidesignwatch.com?aff=61\nCheck Out The New MERCH: https://teespring.com/get-low-t-shirt",
  "synopsis": "Song: Dillon Francis, DJ Snake - Get Low\nCheck The amazing Pagani Design Watches\nGreat price and great quality :\nhttps://www.paganidesignwatch.com?aff=61\nCheck Out The New MERCH: https://teespring.com/get-low-t-shirt"
        }
    }
 */

class FileTag {
  final Map<String, dynamic> _map;
  const new(this._map);

  /// source map
  Map<String, dynamic> get sourceMap => _map;

  String get majorBrand => _map['major_brand'];
  int get minorVersion => .parse(_map['minor_version']);
  String get compatibleBrands => _map['compatible_brands'];
  String get encoder => _map['encoder'];
  String get title => titleOrNull!;
  String get artist => artistOrNull!;
  String get genre => genreOrNull!;
  String get date => dateOrNull!;
  String get comment => commentOrNull!;
  String get description => descriptionOrNull!;
  String get synopsis => synopsisOrNull!;
  String get album => albumOrNull!;

  String? get commentOrNull {
    final res = _map['comment'];
    if (res == null) return null;
    return res;
  }

  String? get descriptionOrNull {
    final res = _map['description'];
    if (res == null) return null;
    return res;
  }

  String? get synopsisOrNull {
    final res = _map['synopsis'];
    if (res == null) return null;
    return res;
  }

  String? get titleOrNull {
    final res = _map['title'];
    if (res == null) return null;
    return res;
  }

  String? get artistOrNull {
    final res = _map['artist'];
    if (res == null) return null;
    return res;
  }

  String? get genreOrNull {
    final res = _map['genre'];
    if (res == null) return null;
    return res;
  }

  String? get dateOrNull {
    final res = _map['date'];
    if (res == null) return null;
    return res;
  }

  String? get albumOrNull {
    final res = _map['album'];
    if (res == null) return null;
    return res;
  }
}
