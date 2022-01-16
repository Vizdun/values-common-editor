enum VCsection { loadfile, questions, buttons, results, general, axes }

class VCValue {
  VCValue(
      {required this.name,
      required this.description,
      required this.color,
      required this.icon});
  String name;
  String description;
  String color;
  String icon;

  factory VCValue.fromJson(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final description = data['description'] as String;
    final color = data['color'] as String;
    final icon = data['icon'] as String;
    return VCValue(
        color: color, description: description, icon: icon, name: name);
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'description': description, 'color': color, 'icon': icon};
}

class VCAxis {
  VCAxis(
      {required this.left,
      required this.right,
      required this.tiers,
      required this.id,
      required this.name});
  String id;
  String name;
  VCValue left;
  VCValue right;
  List<String> tiers;

  factory VCAxis.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as String;
    final name = data['name'] as String;
    final left = data['left'] as Map<String, dynamic>;
    final right = data['right'] as Map<String, dynamic>;
    final tiers = data['tiers'] as List<dynamic>;
    return VCAxis(
        name: name,
        id: id,
        left: VCValue.fromJson(left),
        right: VCValue.fromJson(right),
        tiers: tiers.map((e) => e.toString()).toList());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'left': left.toJson(),
        'right': right.toJson(),
        'tiers': tiers,
      };
}

class VCGeneral {
  VCGeneral({
    required this.title,
    required this.github,
    required this.description,
    required this.valQuestion,
    required this.valDescription,
    required this.link,
    required this.version,
    required this.favicon,
  });
  String title;
  String github;
  String description;
  String valQuestion;
  String valDescription;
  String link;
  String version;
  String favicon;

  factory VCGeneral.fromJson(Map<String, dynamic> data) {
    final title = data['title'] as String;
    final github = data['github'] as String;
    final description = data['description'] as String;
    final valQuestion = data['valQuestion'] as String;
    final valDescription = data['valDescription'] as String;
    final link = data['link'] as String;
    final version = data['version'] as String;
    final favicon = data['favicon'] as String;
    return VCGeneral(
        description: description,
        favicon: favicon,
        github: github,
        link: link,
        title: title,
        valDescription: valDescription,
        valQuestion: valQuestion,
        version: version);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'github': github,
        'description': description,
        'valQuestion': valQuestion,
        'valDescription': valDescription,
        'link': link,
        'version': version,
        'favicon': favicon
      };
}

class VCButton {
  VCButton(
      {required this.name,
      required this.modifier,
      required this.color,
      required this.focusColor});
  String name;
  double modifier;
  String color;
  String focusColor;

  factory VCButton.fromJson(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final modifier = data['modifier'] as dynamic;
    final color = data['color'] as String;
    final focusColor = data['focusColor'] as String;
    return VCButton(
        color: color,
        focusColor: focusColor,
        modifier: modifier.runtimeType == int ? modifier.toDouble() : modifier,
        name: name);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'modifier': modifier,
        'color': color,
        'focusColor': focusColor
      };
}

class VCQuestion {
  VCQuestion({required this.question, required this.effect});
  String question;
  Map<String, double> effect;

  factory VCQuestion.fromJson(Map<String, dynamic> data) {
    final question = data['question'] as String;
    final effect = data['effect'] as Map<String, dynamic>;
    return VCQuestion(
        effect: effect.map((key, value) =>
            MapEntry(key, value.runtimeType == int ? value.toDouble() : value)),
        question: question);
  }

  Map<String, dynamic> toJson() => {'question': question, 'effect': effect};
}

class VCResult {
  VCResult({required this.name, required this.stats});
  String name;
  Map<String, double> stats;

  factory VCResult.fromJson(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final stats = data['stats'] as Map<String, dynamic>;
    return VCResult(
        stats: stats.map((key, value) =>
            MapEntry(key, value.runtimeType == int ? value.toDouble() : value)),
        name: name);
  }

  Map<String, dynamic> toJson() => {'name': name, 'stats': stats};
}

class VCJson {
  VCJson(
      {required this.axes,
      required this.buttons,
      required this.general,
      required this.questions,
      required this.results});
  List<VCAxis> axes;
  List<VCButton> buttons;
  VCGeneral general;
  List<VCQuestion> questions;
  List<VCResult> results;

  factory VCJson.fromJson(Map<String, dynamic> data) {
    final axes = data['axes'] as List<dynamic>;
    final buttons = data['buttons'] as List<dynamic>;
    final general = data['general'] as Map<String, dynamic>;
    final questions = data['questions'] as List<dynamic>;
    final results = data['results'] as List<dynamic>;
    return VCJson(
        axes: axes.map((e) => VCAxis.fromJson(e)).toList(),
        buttons: buttons.map((e) => VCButton.fromJson(e)).toList(),
        general: VCGeneral.fromJson(general),
        questions: questions.map((e) => VCQuestion.fromJson(e)).toList(),
        results: results.map((e) => VCResult.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() => {
        'axes': axes.map((e) => e.toJson()).toList(),
        'buttons': buttons.map((e) => e.toJson()).toList(),
        'general': general.toJson(),
        'questions': questions.map((e) => e.toJson()).toList(),
        'results': results.map((e) => e.toJson()).toList(),
      };
}
