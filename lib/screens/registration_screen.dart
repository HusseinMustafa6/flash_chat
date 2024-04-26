import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/my_widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  bool textState = true;
  bool? showSpinner = false ;

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
                email = value;
              },
              decoration: kTextFieldInputDecoration.copyWith(hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.black38)
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldInputDecoration.copyWith(
                suffixIcon: IconButton(onPressed:(){
                  setState(() {
                    textState =!textState;
                  });


                }, icon: Icon(textState? Icons.visibility:Icons.visibility_off)),
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: Colors.black38),

              ),
             keyboardType: TextInputType.visiblePassword,
              obscureText: textState,
            ),
            SizedBox(
              height: 24.0,
            ),
            CustomButton(buttonColor: Colors.blueAccent,
                onPressed: () async{
                 print(email);
                 print(password);
                 EasyLoading.show(status:'Loading...',dismissOnTap: true);
                 try{
                   final UserCredential  newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  //if the registre is copleted the user will be saved into auth obj as auth.currentUser
                   final newUser2 = newUser.user;
                  if(newUser2 != null) {
                    EasyLoading.showSuccess('Done !');
                    Navigator.pushNamed(context, '/chat_screen');
                  }

                 }
                 catch(e){
                   print('Error');
                 }

                },
                buttonText: 'Register')
          ],
        ),
      ),
    );
  }
}

