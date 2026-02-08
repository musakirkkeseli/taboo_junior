// import 'package:flutter/material.dart';

// import '../../model/solo_game_model.dart';
// import 'custom_level_button.dart';

// class LevelListviewWidget extends StatelessWidget {
//   final List<SoloGame> levelList;
//   const LevelListviewWidget({super.key, required this.levelList});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       controller: ScrollController(initialScrollOffset: 999999),
//       child: Column(
//         children: [
//           ListView.builder(
//             padding: EdgeInsets.all(0),
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: levelList.length,
//             itemBuilder: (context, index) {
//               return Column(
//                 children: [
//                   CustomLevelButton(
//                     level: levelList[index],
//                   ),
//                   Container(
//                     width: 10,
//                     height: 57,
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [Color(0xff9EBBFF), Color(0xffFFFFFF)])),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
