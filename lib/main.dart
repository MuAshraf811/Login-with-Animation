import 'package:flutter/material.dart';
import 'package:login_rive_screen_animation/login.dart';

void main() {
  runApp(const AnimationRive());
}


class AnimationRive extends StatelessWidget {
  const AnimationRive({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}