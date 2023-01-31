import 'db_helper.dart';

// Peraonテーブルの定義
class Person {
  int? id;
  String degree;
  String name;
  String icon;


  Person({
    this.id,
    required this.degree,
    required this.name,
    required this.icon,
  });

  // 更新時のデータを入力項目からコピーする処理
  Person copy({
    int? id,
    String? name,
    String? icon,
    String? degree,
  }) =>
      Person(
        id: id ?? this.id,
        degree: degree ?? this.degree,
        name: name ?? this.name,
        icon: icon ?? this.icon,
      );

  static Person fromJson(Map<String, Object?> json) => Person(
    id: json[PcolumnId] as int,
    degree: json[PcolumnDegree] as String,
    name: json[PcolumnName] as String,
    icon: json[PcolumnIcon] as String,
  );

  Map<String, Object> toJson() => {
    PcolumnDegree:degree,
    PcolumnName:name,
    PcolumnIcon:icon,
  };
}