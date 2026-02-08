// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../features/utility/const/constant_string.dart';
// import '../cubit/solo_game_cubit.dart';

// class SoloGameView extends StatefulWidget {
//   final String word;
//   const SoloGameView({super.key, required this.word});

//   @override
//   State<SoloGameView> createState() => _SoloGameViewState();
// }

// class _SoloGameViewState extends State<SoloGameView> {
//   late List<TextEditingController> _controllers;
//   late List<FocusNode> _focusNodes;
//   late List<bool> _hasError;
//   late List<String> _previousValues;
//   bool _isProcessingBackspace = false;

//   @override
//   void initState() {
//     super.initState();
//     final wordLength = widget.word.length;
//     _controllers = List.generate(wordLength, (index) => TextEditingController());
//     _focusNodes = List.generate(wordLength, (index) => FocusNode());
//     _hasError = List.generate(wordLength, (index) => false);
//     _previousValues = List.generate(wordLength, (index) => '');

//     // Her controller'a listener ekle (boş hücrede backspace için)
//     for (int i = 0; i < wordLength; i++) {
//       _controllers[i].addListener(() => _handleControllerChange(i));
//     }

//     // İlk alana otomatik odaklan
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_focusNodes.isNotEmpty) {
//         _focusNodes[0].requestFocus();
//       }
//     });
//   }

//   void _handleControllerChange(int index) {
//     final text = _controllers[index].text;
//     final prevText = _previousValues[index];
    
//     // Boş hücrede backspace yapıldı
//     if (text.isEmpty && prevText.isEmpty && _focusNodes[index].hasFocus && !_isProcessingBackspace) {
//       if (index > 0) {
//         _isProcessingBackspace = true;
//         _focusNodes[index - 1].requestFocus();
//         _controllers[index - 1].clear();
//         setState(() {
//           _previousValues[index - 1] = '';
//           _hasError[index - 1] = false;
//         });
//         Future.delayed(Duration(milliseconds: 100), () {
//           _isProcessingBackspace = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var focusNode in _focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }

//   void _onCharacterChanged(int index, String value) {
//     if (_isProcessingBackspace) return;
    
//     if (value.isEmpty) {
//       // Silme işlemi - bu hücredeki karakteri sil
//       setState(() {
//         _hasError[index] = false;
//         _previousValues[index] = '';
//       });
//       // Boş hücrede tekrar silme yapıldığında _handleControllerChange devreye girecek
//       return;
//     }

//     final expectedChar = widget.word[index].toLowerCase();
//     final enteredChar = value.toLowerCase();

//     setState(() {
//       if (enteredChar == expectedChar) {
//         _hasError[index] = false;
//         _previousValues[index] = value;
//         // Doğru karakter, sonraki alana geç
//         if (index < widget.word.length - 1) {
//           _focusNodes[index + 1].requestFocus();
//         } else {
//           // Son karakter de doğruysa klavyeyi kapat
//           _focusNodes[index].unfocus();
//           _showSuccessDialog();
//         }
//       } else {
//         _hasError[index] = true;
//         _previousValues[index] = value;
//         // Yanlış karakter, aynı alanda kal
//       }
//     });
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Tebrikler!'),
//         content: Text('Kelimeyi doğru tahmin ettiniz: ${widget.word}'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               Navigator.of(context).pop();
//             },
//             child: Text('Tamam'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => SoloGameCubit(widget.word),
//       child: BlocConsumer<SoloGameCubit, SoloGameState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Kelimeyi Tahmin Et'),
//             ),
//             body: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(ConstantString.gameBg),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Kelime ${widget.word.length} harflidir',
//                         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                       SizedBox(height: 40),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(
//                           widget.word.length,
//                           (index) => Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: _buildCharacterField(index),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCharacterField(int index) {
//     return Container(
//       width: 50,
//       height: 60,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(
//           color: _hasError[index] ? Colors.red : Colors.blue,
//           width: _hasError[index] ? 3 : 2,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextField(
//         controller: _controllers[index],
//         focusNode: _focusNodes[index],
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: _hasError[index] ? Colors.red : Colors.black,
//         ),
//         maxLength: 1,
//         decoration: InputDecoration(
//           counterText: '',
//           border: InputBorder.none,
//         ),
//         inputFormatters: [
//           FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZğüşıöçĞÜŞİÖÇ]')),
//         ],
//         onChanged: (value) {
//           _onCharacterChanged(index, value);
//         },
//         keyboardType: TextInputType.text,
//         textCapitalization: TextCapitalization.characters,
//         onSubmitted: (value) {
//           // Enter tuşuna basıldığında
//           if (index < widget.word.length - 1) {
//             _focusNodes[index + 1].requestFocus();
//           }
//         },
//       ),
//     );
//   }
// }
