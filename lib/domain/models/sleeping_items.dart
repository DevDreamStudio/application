final class SleepingItemsList {
  List<SleepingItem> items = [];

  SleepingItemsList({required this.items});

  SleepingItemsList.fromJson(List<dynamic> json) {
    items = json.map((item) => SleepingItem.fromJson(item)).toList();
  }
}

class SleepingItem {
  int? pk;
  String? photo;

  SleepingItem({this.pk, this.photo});

  SleepingItem.fromJson(Map<String, dynamic> json) {
    pk = json['pk'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pk'] = pk;
    data['photo'] = photo;
    return data;
  }
}
