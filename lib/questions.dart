import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'menu.dart';
import 'vc_classes.dart';

class VCQuestionsWidget extends StatefulWidget {
  VCQuestionsWidget({Key? key, required this.questions, required this.axes})
      : super(key: key);

  List<VCQuestion> questions;
  List<VCAxis> axes;

  @override
  State<VCQuestionsWidget> createState() => _VCQuestionsWidgetState();
}

class _VCQuestionsWidgetState extends State<VCQuestionsWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
    _controller.text = widget.questions[currentQuestion].question;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int currentQuestion = 0;

  void trueVoid(dynamic newVal) {
    setState(() {
      currentQuestion = newVal as int;
      _controller.text = widget.questions[currentQuestion].question;
    });
  }

  void sliderChange(double newVal, String id) {
    setState(() {
      widget.questions[currentQuestion].effect[id] = newVal;
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
                  return widget.questions.map((e) => e.question).toList();
                }, getcurrentItem: () {
                  return currentQuestion;
                }, setcurrentItem: (int item) {
                  setState(() {
                    currentQuestion = item;
                    _controller.text =
                        widget.questions[currentQuestion].question;
                  });
                }, moveCallback: (int oldpos, int newpos) {
                  var moved = widget.questions[oldpos];
                  setState(() {
                    widget.questions.removeAt(oldpos);
                    widget.questions.insert(newpos, moved);
                  });
                }, addCallback: (int pos) {
                  setState(() {
                    widget.questions.insert(pos,
                        VCQuestion(question: "Sample question", effect: {}));
                  });
                }, removeCallback: (int pos) {
                  setState(() {
                    widget.questions.removeAt(pos);
                  });
                }),
              );
            }),
        TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller: _controller,
          decoration: const InputDecoration(labelText: "Question text"),
          onChanged: (String value) {
            setState(() {
              widget.questions[currentQuestion].question = value;
            });
          },
        ),
        ...(widget.axes.map((e) => Column(
              children: [
                Text(e.id),
                SfSlider(
                    max: 20,
                    min: -20,
                    stepSize: 2.5,
                    showLabels: true,
                    enableTooltip: true,
                    value: widget.questions[currentQuestion].effect[e.id] ?? 0,
                    onChanged: (r) => {sliderChange(r, e.id)}),
              ],
            )))
      ],
    );
  }
}
