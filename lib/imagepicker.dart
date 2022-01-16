import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:io';

class VCImageWidget extends StatefulWidget {
  VCImageWidget({Key? key, required this.icon}) : super(key: key);

  String icon;

  @override
  State<VCImageWidget> createState() => _VCImageWidgetState();
}

class _VCImageWidgetState extends State<VCImageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _pickFile() async {
    String text = "";

    var picked = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["svg"]);

    if (picked != null) {
      if (picked.files.first.bytes != null) {
        text = utf8.decode(picked.files.first.bytes!.toList());
      } else {
        final File file = File(picked.files.first.path ?? "");
        text = await file.readAsString();
      }

      setState(() {
        widget.icon =
            "data:image/svg+xml;base64," + base64Encode(text.codeUnits);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 150,
        onPressed: _pickFile,
        icon: SvgPicture.memory(
          base64Decode(widget.icon.substring(26)),
          height: 100,
          width: 100,
        ));
  }
}
