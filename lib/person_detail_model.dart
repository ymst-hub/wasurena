import 'db_helper.dart';

// persondetailテーブルの定義
class PersonDetail {
  int? serial;
  String id;
  String flag;
  String detail;

  PersonDetail({
    this.serial,
    required this.id,
    required this.flag,
    required this.detail,
  });
  // 更新時のデータを入力項目からコピーする処理
  PersonDetail copy({
    int? serial,
    String? id,
    String? flag,
    String? detail,
  }) =>
      PersonDetail(
        serial: serial ?? this.serial,
        id: id ?? this.id,
        flag: flag ?? this.flag,
        detail: detail ?? this.detail,
      );

  static PersonDetail fromJson(Map<String, Object?> json) => PersonDetail(
    serial: json[DcolumnSerial] as int,
    id: json[DcolumnId] as String,
    flag: json[DcolumnFlag] as String,
    detail: json[DcolumnDetail] as String,
  );

  Map<String, Object> toJson() => {
    DcolumnId: id,
    DcolumnFlag:flag,
    DcolumnDetail:detail,
  };
}