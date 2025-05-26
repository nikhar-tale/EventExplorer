import 'package:event_explorer/utils/utils.dart';

class Category {
  String? category;
  String? data;

  Category({this.category, this.data});

  Category.fromJson(Map<String, dynamic> json) {
    category = Utils.capitalizeFirstLetter(json['category']);
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['category'] = category;
    data['data'] = this.data;
    return data;
  }
}
