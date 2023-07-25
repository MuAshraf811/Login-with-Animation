// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_rive_screen_animation/riveEnum.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Artboard? myArtboard;
  late RiveAnimationController idleController;
  late RiveAnimationController lookLeftController;
  late RiveAnimationController handsUpController;
  late RiveAnimationController handsDownController;
  late RiveAnimationController lookRightController;
  late RiveAnimationController successController;
  late RiveAnimationController failController;
  final passWordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    idleController = SimpleAnimation(RiveEnum.idle.name);
    lookLeftController = SimpleAnimation(RiveEnum.Look_down_left.name);
    handsUpController = SimpleAnimation(RiveEnum.Hands_up.name);
    handsDownController = SimpleAnimation(RiveEnum.hands_down.name);
    lookRightController = SimpleAnimation(RiveEnum.Look_down_right.name);
    successController = SimpleAnimation(RiveEnum.success.name);
    failController = SimpleAnimation(RiveEnum.fail.name);
    rootBundle.load('assets/animated_login_screen.riv').then((value) {
      final file = RiveFile.import(value);
      final artboard = file.mainArtboard;
      artboard.addController(idleController);
      setState(() {
        myArtboard = artboard;
      });
    });
    checkFocusNodeInPassword();
  }

  void validate() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addController(successController);
        return;
      } else {
        addController(failController);
      }
    });
  }

  void checkFocusNodeInPassword() {
    passWordFocus.addListener(() {
      if (passWordFocus.hasFocus) {
        addController(handsUpController);
      } else if (!passWordFocus.hasFocus) {
        addController(handsDownController);
      }
    });
  }

  void removeAllControlleres() {
    myArtboard?.artboard.removeController(idleController);
    myArtboard?.artboard.removeController(lookLeftController);
    myArtboard?.artboard.removeController(lookRightController);
    myArtboard?.artboard.removeController(successController);
    myArtboard?.artboard.removeController(failController);
    myArtboard?.artboard.removeController(handsDownController);
    myArtboard?.artboard.removeController(handsUpController);
  }

  void addController(RiveAnimationController cont) {
    removeAllControlleres();
    myArtboard?.artboard.addController(cont);
    debugPrint(cont.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 220,
                  child: myArtboard == null
                      ? const SizedBox.shrink()
                      : Rive(artboard: myArtboard!),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field should\'t be empty';
                    } else if (value.length <= 13) {
                      return 'at least should be 14 charcters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length <= 12 && value.isNotEmpty) {
                      addController(lookLeftController);
                    } else {
                      addController(lookRightController);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your E-mail',
                    labelText: 'E-mail',
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.email_rounded),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field should\'t be empty';
                    } else if (value.length <= 7) {
                      return 'at least should be 8 charcters';
                    }
                    return null;
                  },
                  focusNode: passWordFocus,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.remove_red_eye_rounded),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TextButton(
                      onPressed: () {
                        passWordFocus.unfocus();
                        validate();
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
