import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test1/models/data.dart';
import 'package:test1/views/report_creator.dart';
import 'package:test1/views/report_viewer.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  final jsonText =
                      await rootBundle.loadString("lib/devData/data1.json");
                  if (!context.mounted) return;
                  final json = jsonDecode(jsonText);
                  final model = ReportDataModel.fromJson(json);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportCreator(model: model)));
                },
                child: Text("Viewer")),
            ElevatedButton(
              onPressed: () {
                final model =
                    ReportDataModel(type: ReportDataType.object, children: []);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportCreator(model: model),
                    ));
              },
              child: Text("Creator"),
            )
          ],
        ),
      ),
    );
  }
}
