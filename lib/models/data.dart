import 'package:json_annotation/json_annotation.dart';
part 'data.g.dart';

@JsonSerializable()
class ReportDataModel {
  ReportDataModel({required this.type, this.key, this.value, this.children});

  ReportDataType type;
  dynamic value;
  List<ReportDataModel>? children;
  String? key;

  factory ReportDataModel.fromJson(Map<String, dynamic> json) =>
      _$ReportDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDataModelToJson(this);
}

enum ReportDataType { string, integer, number, datetime, photo, list, object }
//so it looks like to me that the only difference data and a schema is that schema has all values set to null and lists only have one item
