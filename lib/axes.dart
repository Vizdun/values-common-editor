import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:values_common_editor_flutter/imagepicker.dart';

import 'menu.dart';
import 'vc_classes.dart';

class VCTierWidget extends StatefulWidget {
  VCTierWidget({Key? key, required this.tier, required this.setTier})
      : super(key: key);

  String tier;
  void Function(String newTier) setTier;

  @override
  State<VCTierWidget> createState() => _VCTierWidgetState();
}

class _VCTierWidgetState extends State<VCTierWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
    _controller.text = widget.tier;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VCTierWidget tierWidget) {
    _controller.text = widget.tier;
    super.didUpdateWidget(tierWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: TextField(
      controller: _controller,
      decoration: const InputDecoration(labelText: "Tier"),
      onChanged: (String value) {
        widget.setTier(value);
      },
    ));
  }
}

class VCValueWidget extends StatefulWidget {
  VCValueWidget({Key? key, required this.value}) : super(key: key);

  VCValue value;

  @override
  State<VCValueWidget> createState() => _VCValueWidgetState();
}

class _VCValueWidgetState extends State<VCValueWidget> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
    _descController.addListener(() {});
    _controller.text = widget.value.name;
    _descController.text = widget.value.description;
  }

  @override
  void dispose() {
    _controller.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VCValueWidget valueWidget) {
    _controller.text = widget.value.name;
    _descController.text = widget.value.description;
    super.didUpdateWidget(valueWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: "Value name"),
            onChanged: (String value) {
              setState(() {
                widget.value.name = value;
              });
            },
          ),
          TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: _descController,
            decoration: const InputDecoration(labelText: "Value Description"),
            onChanged: (String value) {
              setState(() {
                widget.value.description = value;
              });
            },
          ),
          const Text("Color"),
          ColorPicker(
            enableAlpha: false,
            portraitOnly: true,
            hexInputBar: true,
            pickerColor: hexToColor(widget.value.color),
            onColorChanged: (r) =>
                {widget.value.color = '#${r.value.toRadixString(16)}'},
          ),
          VCImageWidget(icon: widget.value.icon)
        ],
      ),
    );
  }
}

class VCAxesWidget extends StatefulWidget {
  VCAxesWidget({Key? key, required this.axes}) : super(key: key);

  List<VCAxis> axes;

  @override
  State<VCAxesWidget> createState() => _VCAxesWidgetState();
}

Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
  return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
}

class _VCAxesWidgetState extends State<VCAxesWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
    _controller.text = widget.axes[currentAxis].name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int currentAxis = 0;

  void trueVoid(dynamic newVal) {
    setState(() {
      currentAxis = newVal as int;
      _controller.text = widget.axes[currentAxis].name;
    });
  }

  bool leftExpanded = false;
  bool rightExpanded = false;

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
                        return widget.axes.map((e) => e.name).toList();
                      }, getcurrentItem: () {
                        return currentAxis;
                      }, setcurrentItem: (int item) {
                        setState(() {
                          currentAxis = item;
                          _controller.text = widget.axes[currentAxis].name;
                        });
                      }, moveCallback: (int oldpos, int newpos) {
                        var moved = widget.axes[oldpos];
                        setState(() {
                          widget.axes.removeAt(oldpos);
                          widget.axes.insert(newpos, moved);
                        });
                      }, addCallback: (int pos) {
                        setState(() {
                          widget.axes.insert(
                              pos,
                              VCAxis(
                                  left: VCValue(
                                      name: "Sample left value",
                                      description: "",
                                      color: "#FFFFFF",
                                      icon: widget.axes[0].left.icon),
                                  right: VCValue(
                                      name: "Sample right value",
                                      description: "",
                                      color: "#FFFFFF",
                                      icon: widget.axes[0].right.icon),
                                  tiers: ["", "", "", "", "", "", ""],
                                  id: "Sample axis",
                                  name: "Sample axis"));
                        });
                      }, removeCallback: (int pos) {
                        setState(() {
                          widget.axes.removeAt(pos);
                        });
                      }));
            }),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: "Axis name"),
          onChanged: (String value) {
            setState(() {
              widget.axes[currentAxis].name = value;
              widget.axes[currentAxis].id = value;
            });
          },
        ),
        ExpansionPanelList(
          expansionCallback: (int item, bool status) {
            switch (item) {
              case 0:
                setState(() {
                  leftExpanded = !status;
                });
                break;
              case 1:
                setState(() {
                  rightExpanded = !status;
                });
                break;
            }
          },
          children: [
            ExpansionPanel(
                isExpanded: leftExpanded,
                headerBuilder: (context, isExpanded) {
                  return Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text("Left"));
                },
                body: VCValueWidget(value: widget.axes[currentAxis].left)),
            ExpansionPanel(
                isExpanded: rightExpanded,
                headerBuilder: (context, isExpanded) {
                  return Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text("Right"));
                },
                body: VCValueWidget(value: widget.axes[currentAxis].right))
          ],
        ),
        Row(
          children: [
            VCTierWidget(
              tier: widget.axes[currentAxis].tiers[0],
              setTier: (String newTier) {
                widget.axes[currentAxis].tiers[0] = newTier;
              },
            ),
            VCTierWidget(
                tier: widget.axes[currentAxis].tiers[1],
                setTier: (String newTier) {
                  widget.axes[currentAxis].tiers[1] = newTier;
                }),
            VCTierWidget(
                tier: widget.axes[currentAxis].tiers[2],
                setTier: (String newTier) {
                  widget.axes[currentAxis].tiers[2] = newTier;
                })
          ],
        ),
        Row(
          children: [
            VCTierWidget(
                tier: widget.axes[currentAxis].tiers[3],
                setTier: (String newTier) {
                  widget.axes[currentAxis].tiers[3] = newTier;
                })
          ],
        ),
        Row(
          children: [
            VCTierWidget(
                tier: widget.axes[currentAxis].tiers[4],
                setTier: (String newTier) {
                  widget.axes[currentAxis].tiers[4] = newTier;
                }),
            VCTierWidget(
                tier: widget.axes[currentAxis].tiers[5],
                setTier: (String newTier) {
                  widget.axes[currentAxis].tiers[5] = newTier;
                }),
            VCTierWidget(
                tier: widget.axes[currentAxis].tiers[6],
                setTier: (String newTier) {
                  widget.axes[currentAxis].tiers[6] = newTier;
                })
          ],
        )
      ],
    );
  }
}
