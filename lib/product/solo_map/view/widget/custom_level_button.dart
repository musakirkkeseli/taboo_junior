// import 'package:flutter/material.dart';

// import '../../../../features/utility/const/constant_string.dart';
// import '../../model/solo_game_model.dart';

// class CustomLevelButton extends StatelessWidget {
//   final SoloGameModel level;
//   const CustomLevelButton({super.key, required this.level});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Image(
//           image: AssetImage(bgImage(level.status)),
//           height: 106,
//           width: 106,
//         ),
//         Positioned(
//             height: 106,
//             width: 106,
//             child: Center(child: Text(level.id.toString().padLeft(2, '0')))),
//       ],
//     );
//   }

//   bgImage(SoloGameStatus status) {
//     switch (status) {
//       case SoloGameStatus.complated:
//         return ConstantString.complatedLevelBg;
//       case SoloGameStatus.playable:
//         return ConstantString.playableLevelBg;
//       case SoloGameStatus.unplayable:
//         return ConstantString.unplayableLevelBg;
//     }
//   }
// }
