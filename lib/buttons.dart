import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:values_common_editor_flutter/menu.dart';

import 'vc_classes.dart';

class VCButtonsWidget extends StatefulWidget {
  VCButtonsWidget({Key? key, required this.buttons}) : super(key: key);

  List<VCButton> buttons;

  @override
  State<VCButtonsWidget> createState() => _VCButtonsWidgetState();
}

Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
  return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
}

class _VCButtonsWidgetState extends State<VCButtonsWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
    _controller.text = widget.buttons[_currentButton].name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _currentButton = 0;

  void trueVoid(dynamic newVal) {
    setState(() {
      _currentButton = newVal as int;
      _controller.text = widget.buttons[_currentButton].name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => VCMenuWidget(getitems: () {
                        return widget.buttons.map((e) => e.name).toList();
                      }, getcurrentItem: () {
                        return _currentButton;
                      }, setcurrentItem: (int item) {
                        setState(() {
                          _currentButton = item;
                          _controller.text =
                              widget.buttons[_currentButton].name;
                        });
                      }, moveCallback: (int oldpos, int newpos) {
                        var moved = widget.buttons[oldpos];
                        setState(() {
                          widget.buttons.removeAt(oldpos);
                          widget.buttons.insert(newpos, moved);
                        });
                      }, addCallback: (int pos) {
                        setState(() {
                          widget.buttons.insert(
                              pos,
                              VCButton(
                                  name: "Sample button",
                                  modifier: 0,
                                  color: "#FFCCEE",
                                  focusColor: "#EECCFF"));
                        });
                      }, removeCallback: (int pos) {
                        setState(() {
                          widget.buttons.removeAt(pos);
                        });
                      }));
            }),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: "Button text"),
          onChanged: (String value) {
            setState(() {
              widget.buttons[_currentButton].name = value;
            });
          },
        ),
        const Text("Modifier"),
        SfSlider(
            max: 2,
            min: -2,
            stepSize: 0.25,
            showLabels: true,
            enableTooltip: true,
            value: widget.buttons[_currentButton].modifier,
            onChanged: (r) => {
                  setState(() {
                    widget.buttons[_currentButton].modifier = r;
                  })
                }),
        const Text("Color"),
        ColorPicker(
          enableAlpha: false,
          portraitOnly: true,
          hexInputBar: true,
          pickerColor: hexToColor(widget.buttons[_currentButton].color),
          onColorChanged: (r) => {
            widget.buttons[_currentButton].color =
                '#${r.value.toRadixString(16).substring(2)}'
          },
        ),
        const Text("Focused Color"),
        ColorPicker(
            enableAlpha: false,
            portraitOnly: true,
            hexInputBar: true,
            pickerColor: hexToColor(widget.buttons[_currentButton].focusColor),
            onColorChanged: (r) => {
                  widget.buttons[_currentButton].focusColor =
                      '#${r.value.toRadixString(16)}'
                })
      ],
    );
  }
}
