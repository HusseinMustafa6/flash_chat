import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}
class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen' : (BuildContext)=> WelcomeScreen(),
        '/register':(BuildContext)=> RegistrationScreen(),
        '/login':(BuildContext)=> LoginScreen(),
        '/chat_screen':(BuildContext)=> ChatScreen(),

      },
      builder: EasyLoading.init(),
    );
  }
}
