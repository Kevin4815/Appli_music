class Album {
  String? id;
  String? name;
  int? duration;
  String? artistId;
  String? artistName;
  String? artistIdstr;
  String? albumName;
  String? albumId;
  String? licenseCcurl;
  int? position;
  String? releasedate;
  String? albumImage;
  String? audio;
  String? audiodownload;
  String? prourl;
  String? shorturl;
  String? shareurl;
  String? waveform;
  String? image;
  Musicinfo? musicinfo;
  bool? audiodownloadAllowed;

  Album(
      {this.id,
      this.name,
      this.duration,
      this.artistId,
      this.artistName,
      this.artistIdstr,
      this.albumName,
      this.albumId,
      this.licenseCcurl,
      this.position,
      this.releasedate,
      this.albumImage,
      this.audio,
      this.audiodownload,
      this.prourl,
      this.shorturl,
      this.shareurl,
      this.waveform,
      this.image,
      this.musicinfo,
      this.audiodownloadAllowed});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    artistId = json['artist_id'];
    artistName = json['artist_name'];
    artistIdstr = json['artist_idstr'];
    albumName = json['album_name'];
    albumId = json['album_id'];
    licenseCcurl = json['license_ccurl'];
    position = json['position'];
    releasedate = json['releasedate'];
    albumImage = json['album_image'];
    audio = json['audio'];
    audiodownload = json['audiodownload'];
    prourl = json['prourl'];
    shorturl = json['shorturl'];
    shareurl = json['shareurl'];
    waveform = json['waveform'];
    image = json['image'];
    musicinfo = json['musicinfo'] != null
        ? new Musicinfo.fromJson(json['musicinfo'])
        : null;
    audiodownloadAllowed = json['audiodownload_allowed'];
  }

  Object? get results => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['duration'] = this.duration;
    data['artist_id'] = this.artistId;
    data['artist_name'] = this.artistName;
    data['artist_idstr'] = this.artistIdstr;
    data['album_name'] = this.albumName;
    data['album_id'] = this.albumId;
    data['license_ccurl'] = this.licenseCcurl;
    data['position'] = this.position;
    data['releasedate'] = this.releasedate;
    data['album_image'] = this.albumImage;
    data['audio'] = this.audio;
    data['audiodownload'] = this.audiodownload;
    data['prourl'] = this.prourl;
    data['shorturl'] = this.shorturl;
    data['shareurl'] = this.shareurl;
    data['waveform'] = this.waveform;
    data['image'] = this.image;
    if (this.musicinfo != null) {
      data['musicinfo'] = this.musicinfo!.toJson();
    }
    data['audiodownload_allowed'] = this.audiodownloadAllowed;
    return data;
  }
}

class Musicinfo {
  String? vocalinstrumental;
  String? lang;
  String? gender;
  String? acousticelectric;
  String? speed;
  Tags? tags;

  Musicinfo(
      {this.vocalinstrumental,
      this.lang,
      this.gender,
      this.acousticelectric,
      this.speed,
      this.tags});

  Musicinfo.fromJson(Map<String, dynamic> json) {
    vocalinstrumental = json['vocalinstrumental'];
    lang = json['lang'];
    gender = json['gender'];
    acousticelectric = json['acousticelectric'];
    speed = json['speed'];
    tags = json['tags'] != null ? new Tags.fromJson(json['tags']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vocalinstrumental'] = this.vocalinstrumental;
    data['lang'] = this.lang;
    data['gender'] = this.gender;
    data['acousticelectric'] = this.acousticelectric;
    data['speed'] = this.speed;
    if (this.tags != null) {
      data['tags'] = this.tags!.toJson();
    }
    return data;
  }
}

class Tags {
  List<String>? genres;
  List<String>? instruments;
  List<String>? vartags;

  Tags({this.genres, this.instruments, this.vartags});

  Tags.fromJson(Map<String, dynamic> json) {
    genres = json['genres'].cast<String>();
    instruments = json['instruments'].cast<String>();
    vartags = json['vartags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genres'] = this.genres;
    data['instruments'] = this.instruments;
    data['vartags'] = this.vartags;
    return data;
  }
}