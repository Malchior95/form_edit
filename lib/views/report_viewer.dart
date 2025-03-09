import 'package:flutter/material.dart';
import 'package:test1/models/data.dart';
import 'package:intl/intl.dart';

class ReportViewer extends StatelessWidget {
  final ReportDataModel model;
  const ReportViewer({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    assert(model.children != null);
    var rows = model.children!.map((x) => buildDataRow(x, 0)).toList();
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_left),
      ),
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [...rows],
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildDataRow(ReportDataModel model, int nestingLevel) {
    var widget = switch (model.type) {
      ReportDataType.string => ReportTextField(model: model),
      ReportDataType.integer => ReportIntegerField(model: model),
      ReportDataType.datetime => ReportDateTimeField(model: model),
      ReportDataType.number => ReportNumberField(model: model),
      ReportDataType.object =>
        ReportObjectField(model: model, nestingLevel: nestingLevel),
      ReportDataType.list =>
        ReportListField(model: model, nestingLevel: nestingLevel),
      _ => Row(
          children: [
            Text("${model.type}"),
          ],
        )
    };

    return switch (nestingLevel) {
      <= 0 => Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      //1 => wrapLevel1(widget, model.key),
      //>= 2 => wrapLevel2(widget, model.key),
      <= 2 => widget,
      _ => const Text("There will be a button to expand section."),
    };
  }
}

class ReportListField extends StatelessWidget {
  final ReportDataModel model;
  final int nestingLevel;
  const ReportListField(
      {super.key, required this.model, required this.nestingLevel});

  @override
  Widget build(BuildContext context) {
    return buildListField(model, nestingLevel);
  }

  Widget buildListField(ReportDataModel model, int nestingLevel) {
    var rows = model.children!
        .map((x) => Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: ReportViewer.buildDataRow(x, nestingLevel + 1),
            ))
        .toList();
    return Column(
      children: [if (model.key != null) Text(model.key!), ...rows],
    );
  }
}

class ReportObjectField extends StatelessWidget {
  final ReportDataModel model;
  final int nestingLevel;

  const ReportObjectField(
      {super.key, required this.model, required this.nestingLevel});

  @override
  Widget build(BuildContext context) {
    return buildObjectField(model, nestingLevel);
  }

  Widget buildObjectField(ReportDataModel model, int nestingLevel) {
    var rows = model.children!
        .map((x) => ReportViewer.buildDataRow(x, nestingLevel + 1))
        .toList();
    return Column(
      children: [if (model.key != null) Text(model.key!), ...rows],
    );
  }
}

class ReportNumberField extends StatelessWidget {
  final ReportDataModel model;

  const ReportNumberField({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return buildNumberField(model);
  }

  Widget buildNumberField(ReportDataModel model) {
    return Row(
      children: [
        if (model.key != null) Text("${model.key}: "),
        Text("${model.value as double}"),
      ],
    );
  }
}

class ReportDateTimeField extends StatelessWidget {
  final ReportDataModel model;

  const ReportDateTimeField({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return buildDateTimeField(model);
  }

  Widget buildDateTimeField(ReportDataModel model) {
    final datetimeString = model.value as String;
    final datetime = DateTime.parse(datetimeString);
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    final formattedDate = formatter.format(datetime);
    return Row(
      children: [
        if (model.key != null) Text("${model.key}: "),
        Text(formattedDate),
      ],
    );
  }
}

class ReportIntegerField extends StatelessWidget {
  final ReportDataModel model;

  const ReportIntegerField({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return buildIntegerField(model);
  }

  Widget buildIntegerField(ReportDataModel model) {
    return Row(
      children: [
        if (model.key != null) Text("${model.key}: "),
        Text("${model.value as int}"),
      ],
    );
  }
}

class ReportTextField extends StatelessWidget {
  final ReportDataModel model;
  const ReportTextField({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return buildTextField(model);
  }

  Widget buildTextField(ReportDataModel model) {
    return Row(
      children: [
        if (model.key != null) Text("${model.key}: "),
        Text(model.value as String),
      ],
    );
  }
}
