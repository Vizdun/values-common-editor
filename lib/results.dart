import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'menu.dart';
import 'vc_classes.dart';

class VCResultsWidget extends StatefulWidget {
  VCResultsWidget({Key? key, required this.results, required this.axes})
      : super(key: key);

  List<VCResult> results;
  List<VCAxis> axes;

  @override
  State<VCResultsWidget> createState() => _VCResultsWidgetState();
}

class _VCResultsWidgetState extends State<VCResultsWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
    _controller.text = widget.results[currentResult].name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int currentResult = 0;

  void trueVoid(dynamic newVal) {
    setState(() {
      currentResult = newVal as int;
      _controller.text = widget.results[currentResult].name;
    });
  }

  void sliderChange(double newVal, String id) {
    setState(() {
      widget.results[currentResult].stats[id] = newVal;
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
                        return widget.results.map((e) => e.name).toList();
                      }, getcurrentItem: () {
                        return currentResult;
                      }, setcurrentItem: (int item) {
                        setState(() {
                          currentResult = item;
                          _controller.text = widget.results[currentResult].name;
                        });
                      }, moveCallback: (int oldpos, int newpos) {
                        var moved = widget.results[oldpos];
                        setState(() {
                          widget.results.removeAt(oldpos);
                          widget.results.insert(newpos, moved);
                        });
                      }, addCallback: (int pos) {
                        setState(() {
                          widget.results.insert(
                              pos, VCResult(name: "Sample result", stats: {}));
                        });
                      }, removeCallback: (int pos) {
                        setState(() {
                          widget.results.removeAt(pos);
                        });
                      }));
            }),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: "Result text"),
          onChanged: (String value) {
            setState(() {
              widget.results[currentResult].name = value;
            });
          },
        ),
        ...(widget.axes.map((e) => Column(
              children: [
                Text(e.id),
                SfSlider(
                    max: 100,
                    min: 0,
                    stepSize: 5,
                    showLabels: true,
                    enableTooltip: true,
                    value: widget.results[currentResult].stats[e.id] ?? 0,
                    onChanged: (r) => {sliderChange(r, e.id)}),
              ],
            )))
      ],
    );
  }
}
