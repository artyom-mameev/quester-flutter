import 'package:quester_flutter/domain/text_game.dart';

class GamePlayer {
  final List<String> activatedflagsIds = [];

  void activateFlag(String id) {
    activatedflagsIds.add(id);
  }

  void clearFlags() {
    activatedflagsIds.clear();
  }

  List<NextChoice> getNextChoices(RoomNode roomNode) {
    final List<NextChoice> choices = [];

    final List<GameNode> potentialChoices = roomNode.children;

    for (GameNode potentialChoice in potentialChoices) {
      if (potentialChoice is ChoiceNode) {
        RoomNode? nextReachableRoom = getNextReachableRoom(potentialChoice);

        if (nextReachableRoom != null) {
          choices.add(NextChoice(
              text: potentialChoice.name,
              id: potentialChoice.id,
              isFlag: false,
              nextRoomNode: nextReachableRoom));
        }
      }

      if (potentialChoice is FlagNode) {
        // if this is not an activated flag
        if (!activatedflagsIds.contains(potentialChoice.id)) {
          choices.add(NextChoice(
              text: potentialChoice.name,
              id: potentialChoice.id,
              isFlag: true,
              nextRoomNode: roomNode));
        }
      }
    }
    return choices;
  }

  RoomNode? getNextReachableRoom(gameNode) {
    if (gameNode is FlagNode) {
      return null; // flag node can not have children
    }

    RoomNode? nextReachableRoomNode;

    final List<ConditionNode> conditionNodes = [];

    for (GameNode gameNodeChild in gameNode.children) {
      if (gameNodeChild is RoomNode) {
        nextReachableRoomNode = gameNodeChild;
      }
      if (gameNodeChild is ConditionNode) {
        conditionNodes.add(gameNodeChild);
      }
    }

    // check conditions
    for (ConditionNode conditionNode in conditionNodes) {
      /*if conditionNode's flag condition is active and that flag
        is triggered*/
      if (conditionNode.condition.flagState == ConditionFlagState.active &&
              activatedflagsIds.contains(conditionNode.condition.flagId) ||
          /*or if conditionNode's flag condition is not active
            and that flag is triggered (is not present in the list of flags with
            active state)*/
          conditionNode.condition.flagState == ConditionFlagState.notActive &&
              !activatedflagsIds.contains(conditionNode.condition.flagId)) {
        // check if there is a reachable room among conditionNode's children
        RoomNode? nextRoomFromSucceedCondition =
            getNextReachableRoom(conditionNode);
        // and if it is
        if (nextRoomFromSucceedCondition != null) {
          /*return that room as next reachable room, even if reachable room
                already exists (room from succeed condition has priority
                over the normal reachable room)*/
          return nextRoomFromSucceedCondition;
        }
      }
    }
    /*if there is no conditions, or conditions are not succeed, return next
    (normal, default) room*/
    return nextReachableRoomNode;
  }
}

class NextChoice {
  final String id;
  final String text;
  final bool isFlag;
  final GameNode nextRoomNode;

  NextChoice({
    required this.id,
    required this.isFlag,
    required this.text,
    required this.nextRoomNode,
  });
}
