import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:values_common_editor_flutter/axes.dart';
import 'package:values_common_editor_flutter/buttons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:convert';

import 'vc_classes.dart';

import 'questions.dart';
import 'results.dart';
import 'general.dart';

// this is probably not the best idea
import 'package:universal_html/html.dart' as dart_html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Values Common Editor',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VCJson _mainJson = VCJson(
      axes: [],
      buttons: [],
      general: VCGeneral(
          description: '',
          favicon: '',
          github: '',
          link: '',
          title: '',
          valDescription: '',
          valQuestion: '',
          version: ''),
      questions: [],
      results: []);

  VCsection currentSection = VCsection.loadfile;

  String html = "";

  String filepath = "";

  void _pickFile() async {
    String text = "";

    var picked = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["html"]);

    if (picked != null) {
      if (picked.files.first.bytes != null) {
        text = utf8.decode(picked.files.first.bytes!.toList());
      } else {
        final File file = File(picked.files.first.path ?? "");
        text = await file.readAsString();
        filepath = picked.files.first.path!;
      }
      html = text;

      setState(() {
        _mainJson = VCJson.fromJson(
            jsonDecode(text.split("@-@")[1].replaceAll(r"\'", "'")));

        currentSection = VCsection.axes;
      });
    }
  }

  void _saveFile() async {
    if (html.isEmpty) return;

    if (kIsWeb) {
      // prepare
      final bytes = utf8.encode(html.split("@-@")[0] +
          "@-@" +
          jsonEncode(_mainJson.toJson()).replaceAll("'", "\\'") +
          "@-@" +
          html.split("@-@").last);
      final blob = dart_html.Blob([bytes]);
      final url = dart_html.Url.createObjectUrlFromBlob(blob);
      final anchor =
          dart_html.document.createElement('a') as dart_html.AnchorElement
            ..href = url
            ..style.display = 'none'
            ..download = 'index.html';
      dart_html.document.body!.children.add(anchor);

      // download
      anchor.click();

      // cleanup
      dart_html.document.body!.children.remove(anchor);
      dart_html.Url.revokeObjectUrl(url);
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final result = await FilePicker.platform
          .saveFile(fileName: "index.html", allowedExtensions: ["html"]);

      if (result == null) return;

      final File file = File(result);
      file.writeAsString(html.split("@-@")[0] +
          "@-@" +
          jsonEncode(_mainJson.toJson()).replaceAll("'", "\\'") +
          "@-@" +
          html.split("@-@").last);
    } else if (Platform.isAndroid) {
      final File file = File(filepath);
      file.writeAsString(html.split("@-@")[0] +
          "@-@" +
          jsonEncode(_mainJson.toJson()).replaceAll("'", "\\'") +
          "@-@" +
          html.split("@-@").last);
    }
  }

  Widget switchMainWidget() {
    switch (currentSection) {
      case VCsection.questions:
        return VCQuestionsWidget(
          questions: _mainJson.questions,
          axes: _mainJson.axes,
        );
      case VCsection.buttons:
        return VCButtonsWidget(buttons: _mainJson.buttons);
      case VCsection.results:
        return VCResultsWidget(
          results: _mainJson.results,
          axes: _mainJson.axes,
        );
      case VCsection.general:
        return VCGeneralWidget(
          general: _mainJson.general,
        );
      case VCsection.axes:
        return VCAxesWidget(axes: _mainJson.axes);
      default:
        return const Text("waiting for file...");
    }
  }

  String activityString() {
    switch (currentSection) {
      case VCsection.questions:
        return "Questions";
      case VCsection.buttons:
        return "Buttons";
      case VCsection.results:
        return "Results";
      case VCsection.general:
        return "Misc";
      case VCsection.axes:
        return "Axes";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(activityString()),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(8),
                    child: switchMainWidget()))),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton(
              onPressed: _saveFile,
              tooltip: 'Save File',
              child: const Icon(Icons.save),
            ),
          ),
          FloatingActionButton(
            onPressed: _pickFile,
            tooltip: 'Open File',
            child: const Icon(Icons.folder),
          ),
        ]),
        drawer: Drawer(
          child: currentSection != VCsection.loadfile
              ? ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      title: const Text('Axes'),
                      onTap: () {
                        setState(() {
                          currentSection = VCsection.axes;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Buttons'),
                      onTap: () {
                        setState(() {
                          currentSection = VCsection.buttons;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Questions'),
                      onTap: () {
                        setState(() {
                          currentSection = VCsection.questions;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Results'),
                      onTap: () {
                        setState(() {
                          currentSection = VCsection.results;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Misc'),
                      onTap: () {
                        setState(() {
                          currentSection = VCsection.general;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
