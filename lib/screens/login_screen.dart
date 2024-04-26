import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/my_widgets/custom_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool textState = true;

  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

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
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        height: 200.0,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      //Do something with the user input.
                      email = value;
                    },
                    decoration: kTextFieldInputDecoration.copyWith(
                      hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.black38)

                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      //Do something with the user input.
                      password =value;
                    },
                    decoration: kTextFieldInputDecoration.copyWith(
                        suffixIcon: IconButton(onPressed:(){
                          setState(() {
                            textState =!textState;
                          });


                        }, icon: Icon(textState? Icons.visibility:Icons.visibility_off)),
                      hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.black38)

                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: textState,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  CustomButton(
                      buttonColor: Colors.lightBlueAccent,
                      onPressed: () async {
                    //Implement login functionality.
                        print(email);
                        print(password);
                        EasyLoading.show(status: 'loading...');
                        try {
                          final UserCredential currentUser = await _auth
                              .signInWithEmailAndPassword(
                              email: email, password: password);
                          final currentUser2 = currentUser.user;
                          if (currentUser2 != null) {
                            EasyLoading.showSuccess('Done !');
                            Navigator.pushNamed(context, '/chat_screen');
                          }
                        }catch(e) {
                          print('error');
                        }

                  }, buttonText: 'Log In')

                ]
            )
        ));
  }
}
