// import 'package:flutter/material.dart';

// class LogoTextAnimation extends StatefulWidget {
//   @override
//   _LogoTextAnimationState createState() => _LogoTextAnimationState();
// }

// class _LogoTextAnimationState extends State<LogoTextAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _logoAnimation;
//   late Animation<Offset> _textAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );
//     _logoAnimation = Tween<Offset>(
//       begin: Offset(0, -1),
//       end: Offset(0, 0),
//     ).animate(_controller);
//     _textAnimation = Tween<Offset>(
//       begin: Offset(0, 1),
//       end: Offset(0, 0),
//     ).animate(_controller);
//     _controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Stack(
//           children: [
//             // Background Image
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/p1_2.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Animated Logo
//                   SlideTransition(
//                     position: _logoAnimation,
//                     child: Image.asset(
//                       'assets/p1_1.png',
//                       width: 150,
//                       height: 150,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Animated Text
//                   SlideTransition(
//                     position: _textAnimation,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20.0), // Add left padding
//                       child: Text(
//                         "WELCOME TO AQUATECH",
//                         textAlign: TextAlign.center, // Align text center
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 55,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

