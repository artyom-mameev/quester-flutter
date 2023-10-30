import 'package:intl/intl.dart';

class TextGame {
  final int id;
  final String name;
  final String description;
  final String language;
  final String user;
  final int rating;
  final String date;
  final GameNode rootNode;

  TextGame({
    required this.id,
    required this.name,
    required this.description,
    required this.language,
    required this.rootNode,
    required this.user,
    required this.date,
    required this.rating,
  });

  factory TextGame.fromJson(Map<String, dynamic> json) {
    return TextGame(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      language: json['language'],
      rootNode: GameNode.fromJson(json['rootNode']),
      user: json['user'],
      date: DateFormat("dd.MM.yyyy")
          .format(DateFormat("yyyy-MM-dd@HH:mm:ss.SSS+Z").parse(json['date'])),
      rating: json['rating'].round(),
    );
  }
}

class GameNode {
  final String id;

  GameNode({
    required this.id,
  });

  factory GameNode.fromJson(Map<String, dynamic> json) {
    List<GameNode> children = [];

    for (dynamic child in json['children']) {
      children.add(GameNode.fromJson(child));
    }

    switch (json['type']) {
      case "ROOM":
        return RoomNode(
          id: json['id'],
          name: json['name'],
          description: json['description'],
          children: children,
        );
      case "CHOICE":
        return ChoiceNode(
            name: json['name'], children: children, id: json['id']);
      case "FLAG":
        return FlagNode(name: json['name'], id: json['id']);
      case "CONDITION":
        return ConditionNode(
            condition: Condition.fromJson(json['condition']),
            children: children,
            id: json['id']);
      default:
        return GameNode(id: json['id']);
    }
  }
}

class RoomNode extends GameNode {
  final String name;
  final String description;
  final List<GameNode> children;

  RoomNode(
      {required this.name,
      required this.description,
      required this.children,
      required super.id});
}

class ChoiceNode extends GameNode {
  final String name;
  final List<GameNode> children;

  ChoiceNode({required this.name, required this.children, required super.id});
}

class FlagNode extends GameNode {
  final String name;

  FlagNode({required this.name, required super.id});
}

class ConditionNode extends GameNode {
  final Condition condition;
  final List<GameNode> children;

  ConditionNode(
      {required this.condition, required this.children, required super.id});
}

class Condition {
  final String flagId;
  final ConditionFlagState flagState;
  final String nodeId;

  Condition({
    required this.flagId,
    required this.flagState,
    required this.nodeId,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      flagId: json['flagId'],
      flagState: ConditionFlagState.fromString(json['flagState']),
      nodeId: json['nodeId'],
    );
  }
}

enum ConditionFlagState {
  active,
  notActive;

  static ConditionFlagState fromString(String string) {
    switch (string) {
      case "ACTIVE":
        return ConditionFlagState.active;
      case "NOT_ACTIVE":
        return ConditionFlagState.notActive;
    }
    throw Exception("Wrong condition flag state");
  }
}
