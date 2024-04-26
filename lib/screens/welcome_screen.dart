import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/my_widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this,
      duration: Duration(seconds: 1),

    );
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);


    controller.forward();
    controller.addListener(() {
      setState(() {

      });
      print(animation.value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: animation.value * 100,
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  child: AnimatedTextKit(
                    totalRepeatCount: 3,
                    animatedTexts: [
                      TypewriterAnimatedText(
                          'Flash Chat', speed: Duration(milliseconds: 100)),

                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            CustomButton(buttonColor: Colors.lightBlueAccent,
              onPressed: () {
                //Go to login screen.
                Navigator.pushNamed(context, '/login');
              },
              buttonText: 'Log In',
            ),
            CustomButton(buttonColor: Colors.blueAccent, onPressed: () {

              Navigator.pushNamed(context,'/register'); }
            , buttonText: 'Register')

          ],
        ),
      ),
    );
  }
}


