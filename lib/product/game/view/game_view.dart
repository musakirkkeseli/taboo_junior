import 'package:flutter/material.dart';
import 'package:tabumium/product/game/view/widget/game_view_ad_widget.dart';

import '../../../features/model/game_model.dart';

class GameView extends StatelessWidget {
  final GameModel gameModel;
  final String categoryId;
  const GameView(
      {super.key, required this.gameModel, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return GameViewAdWidget(gameModel: gameModel, categoryId: categoryId);
  }
}
