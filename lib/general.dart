import 'package:flutter/material.dart';
import 'package:values_common_editor_flutter/imagepicker.dart';

import 'vc_classes.dart';

class VCGeneralWidget extends StatefulWidget {
  VCGeneralWidget({Key? key, required this.general}) : super(key: key);

  VCGeneral general;

  @override
  State<VCGeneralWidget> createState() => _VCGeneralWidgetState();
}

class _VCGeneralWidgetState extends State<VCGeneralWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController valQController = TextEditingController();
  final TextEditingController valDController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController versionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.general.title;
    githubController.text = widget.general.github;
    descController.text = widget.general.description;
    valQController.text = widget.general.valQuestion;
    valDController.text = widget.general.valDescription;
    linkController.text = widget.general.link;
    versionController.text = widget.general.version;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: "Title"),
          onChanged: (String value) {
            setState(() {
              widget.general.title = value;
            });
          },
        ),
        TextField(
          controller: githubController,
          decoration: const InputDecoration(labelText: "Github"),
          onChanged: (String value) {
            setState(() {
              widget.general.github = value;
            });
          },
        ),
        TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller: descController,
          decoration: const InputDecoration(labelText: "Description"),
          onChanged: (String value) {
            setState(() {
              widget.general.description = value;
            });
          },
        ),
        TextField(
          controller: valQController,
          decoration: const InputDecoration(labelText: "Value question"),
          onChanged: (String value) {
            setState(() {
              widget.general.valQuestion = value;
            });
          },
        ),
        TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller: valDController,
          decoration: const InputDecoration(labelText: "Value description"),
          onChanged: (String value) {
            setState(() {
              widget.general.valDescription = value;
            });
          },
        ),
        TextField(
          controller: linkController,
          decoration: const InputDecoration(labelText: "Link"),
          onChanged: (String value) {
            setState(() {
              widget.general.link = value;
            });
          },
        ),
        TextField(
          controller: versionController,
          decoration: const InputDecoration(labelText: "Version"),
          onChanged: (String value) {
            setState(() {
              widget.general.version = value;
            });
          },
        ),
        VCImageWidget(icon: widget.general.favicon)
      ],
    );
  }
}
