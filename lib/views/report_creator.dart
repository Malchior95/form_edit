import 'package:flutter/material.dart';
import 'package:test1/models/data.dart';
import 'package:intl/intl.dart';

class ReportCreator extends StatefulWidget {
  final ReportDataModel model;
  const ReportCreator({super.key, required this.model});

  @override
  State<ReportCreator> createState() => _ReportCreatorState();

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
      <= 2 => widget,
      _ => const Text("There will be a button to expand section."),
    };
  }
}

class _ReportCreatorState extends State<ReportCreator> {
  @override
  Widget build(BuildContext context) {
    assert(widget.model.children != null);
    final mainControl = Card(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ReportCreatorObjectControl(onPressed: (x) {
              if (x == null) return;
              setState(() {
                widget.model.children!.add(ReportDataModel(type: x));
              });
            })));
    var rows = widget.model.children!
        .map((x) => Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ReportCreator.buildDataRow(x, 0),
              ),
            ))
        .toList();
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
              children: [...rows, mainControl],
            ),
          ),
        ),
      ),
    );
  }
}

class ReportCreatorObjectControl extends StatelessWidget {
  final ValueChanged<ReportDataType?> onPressed;
  static const List<ReportDataType> reportDataTypes = [
    ReportDataType.list,
    ReportDataType.photo,
    ReportDataType.string,
    ReportDataType.number,
    ReportDataType.integer,
    ReportDataType.datetime,
    ReportDataType.object
  ];
  const ReportCreatorObjectControl({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownMenu(
            onSelected: onPressed,
            dropdownMenuEntries: reportDataTypes
                .map((x) => DropdownMenuEntry(value: x, label: x.toString()))
                .toList())
      ],
    );
  }
}

class ReportListField extends StatefulWidget {
  final ReportDataModel model;
  final int nestingLevel;
  const ReportListField(
      {super.key, required this.model, required this.nestingLevel});

  @override
  State<ReportListField> createState() => _ReportListFieldState();
}

class _ReportListFieldState extends State<ReportListField> {
  @override
  Widget build(BuildContext context) {
    return buildListField(widget.model, widget.nestingLevel);
  }

  Widget buildListField(ReportDataModel model, int nestingLevel) {
    model.children ??= [];
    var control = ReportCreatorObjectControl(onPressed: (x) {
      if (x == null) return;
      setState(() {
        widget.model.children!.add(ReportDataModel(type: x));
      });
    });

    var rows = model.children!
        .map((x) => Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: ReportCreator.buildDataRow(x, nestingLevel + 1),
            ))
        .toList();
    return Column(
      children: [if (model.key != null) Text(model.key!), ...rows, control],
    );
  }
}

class ReportObjectField extends StatefulWidget {
  final ReportDataModel model;
  final int nestingLevel;

  const ReportObjectField(
      {super.key, required this.model, required this.nestingLevel});

  @override
  State<ReportObjectField> createState() => _ReportObjectFieldState();
}

class _ReportObjectFieldState extends State<ReportObjectField> {
  @override
  Widget build(BuildContext context) {
    return buildObjectField(widget.model, widget.nestingLevel);
  }

  Widget buildObjectField(ReportDataModel model, int nestingLevel) {
    model.children ??= [];
    var control = ReportCreatorObjectControl(onPressed: (x) {
      if (x == null) return;
      setState(() {
        widget.model.children!.add(ReportDataModel(type: x));
      });
    });
    var rows = model.children!
        .map((x) => ReportCreator.buildDataRow(x, nestingLevel + 1))
        .toList();
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: [if (model.key != null) Text(model.key!), ...rows, control],
      ),
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
    model.value ??= 0.0;
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
    model.value ??= DateTime.now().toString();
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
    model.value ??= 0;
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
    model.value ??= "string";
    return Row(
      children: [
        if (model.key != null) Text("${model.key}: "),
        Text(model.value as String),
      ],
    );
  }
}
