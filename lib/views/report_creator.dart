import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:test1/models/data.dart';
import 'package:intl/intl.dart';

class ReportCreator extends StatefulWidget {
  final ReportDataModel model;
  const ReportCreator({super.key, required this.model});

  @override
  State<ReportCreator> createState() => _ReportCreatorState();

  static Widget buildDataRow(ReportDataModel model) {
    var widget = switch (model.type) {
      ReportDataType.string => ReportTextField(model: model),
      ReportDataType.integer => ReportIntegerField(model: model),
      ReportDataType.datetime => ReportDateTimeField(model: model),
      ReportDataType.number => ReportNumberField(model: model),
      ReportDataType.object => ReportObjectField(model: model),
      ReportDataType.list => ReportListField(model: model),
      _ => Row(
          children: [
            Text("${model.type}"),
          ],
        )
    };

    return widget;
  }
}

class _ReportCreatorState extends State<ReportCreator> {
  @override
  Widget build(BuildContext context) {
    assert(widget.model.children != null);
    final mainControl = Padding(
        padding: EdgeInsets.all(8.0),
        child: ReportCreatorObjectControl(onPressed: (x) {
          setState(() {
            widget.model.children!.add(x);
          });
        }));

    var rows = widget.model.children!
        .map((x) => Card(
              child: Column(
                children: [
                  if (x.key != null)
                    Text(x.key!,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ReportCreator.buildDataRow(x),
                  ),
                ],
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
  final ValueChanged<ReportDataModel> onPressed;

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
        //todo: static creator...
        IconButton(
            onPressed: () async {
              final itemToAdd = await Navigator.push<ReportDataModel?>(context,
                  MaterialPageRoute(builder: (context) {
                final model = ReportDataModel(type: ReportDataType.string);
                return Card(
                  child: Column(
                    children: [
                      const Text("aaa"),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context, model),
                          child: const Text("add"))
                    ],
                  ),
                );
              }));
              if (itemToAdd != null) onPressed(itemToAdd);
            },
            icon: Icon(Icons.add))
      ],
    );
    //return Row(
    //  children: [
    //    DropdownMenu(
    //        onSelected: onPressed,
    //        dropdownMenuEntries: reportDataTypes
    //            .map((x) => DropdownMenuEntry(value: x, label: x.toString()))
    //            .toList())
    //  ],
    //);
  }
}

class ReportListField extends StatefulWidget {
  final ReportDataModel model;

  const ReportListField({super.key, required this.model});

  @override
  State<ReportListField> createState() => _ReportListFieldState();
}

class _ReportListFieldState extends State<ReportListField> {
  @override
  Widget build(BuildContext context) {
    return buildListField(widget.model);
  }

  Widget buildListField(ReportDataModel model) {
    model.children ??= [];
    var control = ReportCreatorObjectControl(onPressed: (x) {
      setState(() {
        widget.model.children!.add(x);
      });
    });

    var rows = model.children!.map((x) {
      if ([ReportDataType.list, ReportDataType.object].contains(x)) {
        return Placeholder(); //todo: navigate to child object
      }
      return ReportCreator.buildDataRow(x);
    }).toList();
    //var rows = model.children!
    //    .map((x) => Padding(
    //          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
    //          child: ReportCreator.buildDataRow(x),
    //        ))
    //    .toList();
    //return Column(
    //  children: [if (model.key != null) Text(model.key!), ...rows, control],
    //);

    return Container(
      decoration: DottedDecoration(
        dash: [10, 5],
        strokeWidth: 3,
        linePosition: LinePosition.left,
        color: Colors.blue,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          children: [...rows, control],
        ),
      ),
    );
  }
}

class ReportObjectField extends StatefulWidget {
  final ReportDataModel model;

  const ReportObjectField({super.key, required this.model});

  @override
  State<ReportObjectField> createState() => _ReportObjectFieldState();
}

class _ReportObjectFieldState extends State<ReportObjectField> {
  @override
  Widget build(BuildContext context) {
    return buildObjectField(widget.model);
  }

  Widget buildObjectField(ReportDataModel model) {
    model.children ??= [];
    var control = ReportCreatorObjectControl(onPressed: (x) {
      setState(() {
        widget.model.children!.add(x);
      });
    });
    var rows = model.children!.map((x) {
      if ([ReportDataType.list, ReportDataType.object].contains(x.type)) {
        return Placeholder(); //todo: navigate to child object
      }
      return ReportCreator.buildDataRow(x);
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
          color: Colors.blue,
          width: 3,
        ))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: [...rows, control],
          ),
        ),
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
        if (model.key != null)
          Text("${model.key}: ", style: TextStyle(fontWeight: FontWeight.bold)),
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
        if (model.key != null)
          Text("${model.key}: ", style: TextStyle(fontWeight: FontWeight.bold)),
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
        if (model.key != null)
          Text("${model.key}: ", style: TextStyle(fontWeight: FontWeight.bold)),
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
        if (model.key != null)
          Text("${model.key}: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(model.value as String),
      ],
    );
  }
}
