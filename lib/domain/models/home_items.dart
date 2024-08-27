final class HomeItemsList {
  List<HomeItem> items = [];

  HomeItemsList({required this.items});

  HomeItemsList.fromJson(List<dynamic> json) {
    items = json.map((item) => HomeItem.fromJson(item)).toList();
  }
}

final class HomeItem {
  int? pk;
  String? title;
  String? link;
  String? photo;

  HomeItem({this.pk, this.title, this.link, this.photo});

  HomeItem.fromJson(Map<String, dynamic> json) {
    pk = json['pk'];
    title = json['title'];
    link = json['link'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pk'] = pk;
    data['title'] = title;
    data['link'] = link;
    data['photo'] = photo;
    return data;
  }
}
