// import 'package:flutter/material.dart';

// import '../../../../features/utility/const/constant_string.dart';
// import '../../model/solo_game_model.dart';
// import 'custom_level_button.dart';

// class LevelListviewWidget extends StatelessWidget {
//   final List<SoloGameModel> levelList;
//   const LevelListviewWidget({super.key, required this.levelList});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.all(0),
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: levelList.length,
//       itemBuilder: (context, index) {
//         return Stack(
//           children: [
//             Column(
//               children: [
//                 CustomLevelButton(
//                   level: levelList[index],
//                 ),
//                 Container(
//                   width: 10,
//                   height: 57,
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [Color(0xff9EBBFF), Color(0xffFFFFFF)])),
//                 ),
//               ],
//             ),
//             Positioned(
//               bottom: 45,
//               left: 30,
//               child: Visibility(
//                   visible: levelList[index].status == SoloGameStatus.complated,
//                   child: Image(
//                       image: AssetImage(ConstantString.complatedLevelIc))),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
