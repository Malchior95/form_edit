// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDataModel _$ReportDataModelFromJson(Map<String, dynamic> json) =>
    ReportDataModel(
      type: $enumDecode(_$ReportDataTypeEnumMap, json['type']),
      key: json['key'] as String?,
      value: json['value'],
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => ReportDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportDataModelToJson(ReportDataModel instance) =>
    <String, dynamic>{
      'type': _$ReportDataTypeEnumMap[instance.type]!,
      'value': instance.value,
      'children': instance.children,
      'key': instance.key,
    };

const _$ReportDataTypeEnumMap = {
  ReportDataType.string: 'string',
  ReportDataType.integer: 'integer',
  ReportDataType.number: 'number',
  ReportDataType.datetime: 'datetime',
  ReportDataType.photo: 'photo',
  ReportDataType.list: 'list',
  ReportDataType.object: 'object',
};
