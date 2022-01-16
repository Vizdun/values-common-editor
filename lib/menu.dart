import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class VCMenuWidget extends StatefulWidget {
  VCMenuWidget(
      {Key? key,
      required this.getitems,
      required this.getcurrentItem,
      required this.setcurrentItem,
      required this.moveCallback,
      required this.addCallback,
      required this.removeCallback})
      : super(key: key);

  List<String> Function() getitems;
  int Function() getcurrentItem;
  void Function(int) setcurrentItem;

  void Function(int, int) moveCallback;
  void Function(int) addCallback;
  void Function(int) removeCallback;

  @override
  State<VCMenuWidget> createState() => _VCMenuWidgetState();
}

class _VCMenuWidgetState extends State<VCMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...widget.getitems().mapIndexed((index, element) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            if (index > 0) {
                              setState(() {
                                widget.moveCallback(index, index - 1);
                              });
                            }
                          },
                          icon: const Icon(Icons.arrow_upward)),
                      IconButton(
                          onPressed: () {
                            if (index < widget.getitems().length) {
                              setState(() {
                                widget.moveCallback(index, index + 1);
                              });
                            }
                          },
                          icon: const Icon(Icons.arrow_downward)),
                    ],
                  ),
                  MaterialButton(
                      onPressed: () {
                        widget.setcurrentItem(index);
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                          child: Text(
                        Platform.isAndroid
                            ? element.substring(0,
                                    element.length < 5 ? element.length : 5) +
                                ((element.length < 5) ? "" : "...")
                            : element,
                      ))),
                  Row(children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            widget.addCallback(index + 1);
                          });
                        },
                        icon: const Icon(Icons.add)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            widget.removeCallback(index);
                          });
                        },
                        icon: const Icon(Icons.delete))
                  ])
                ],
              ))
        ],
      ),
    ));
  }
}
