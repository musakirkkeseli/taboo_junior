// import 'package:flutter/material.dart';
// import 'package:tabu_app/features/utility/const/constant_string.dart';

// import '../../select_category/view/select_category_view.dart';
// import '../model/solo_game_model.dart';
// import 'widget/level_listview_widget.dart';

// class SoloMapView extends StatelessWidget {
//   const SoloMapView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.sizeOf(context).height,
//       width: MediaQuery.sizeOf(context).width,
//       decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage(ConstantString.soloMapBg), fit: BoxFit.fill)),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               LevelListviewWidget(
//                 levelList: [
//                   SoloGameModel(id: 5, status: SoloGameStatus.unplayable),
//                   SoloGameModel(id: 4, status: SoloGameStatus.unplayable),
//                   SoloGameModel(id: 3, status: SoloGameStatus.playable),
//                   SoloGameModel(id: 2, status: SoloGameStatus.complated),
//                   SoloGameModel(id: 1, status: SoloGameStatus.complated),
//                 ],
//               ),
//               SizedBox(height: 43),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => SelectCategoryView()));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 70),
//                   width: MediaQuery.sizeOf(context).width,
//                   height: MediaQuery.sizeOf(context).width * .30,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage(ConstantString.playGameButtonBg))),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
