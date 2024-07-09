class Recents {
  Recents({
    required this.Title,
    required this.URL,
  });
  late final String Title;
  late final String URL;

  Recents.fromJson(Map<String, dynamic> json){
    Title = json['Title']??"";
    URL = json['URL']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Title'] = Title;
    _data['URL'] = URL;
    return _data;
  }
}