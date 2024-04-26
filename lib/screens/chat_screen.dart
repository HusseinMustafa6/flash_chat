import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;


  late String messageText;
  final textMessageController = TextEditingController();

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      final loggedInUser = user;
      if (user != null) {
        print(user.email);
      }
    }
    catch (e) {
      print('error');
    }
  }


  void getMessages() async {
    final messages = await _firestore.collection('messages')
        .get(); //get all docs in collection
    for (var msg in messages.docs) {
      print(msg.data());
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages')
        .snapshots()) // return a list of future snapshots
        {
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                          color: Colors.grey,
                        )
                      ],
                    );

                  }
                  final List? messages = snapshot.data?.docs;

                  var a = messages![0]['text'];
                  final List? messages2 = new List.from(messages.reversed);
                  var a2 = messages2![0]['text'];
                  List<MessageBubble> messagesWidgets = [];
                  bool isMe;
                  for (var msg in messages2) {
                    final messageText = msg.data()['text'];
                    final messageSender = msg.data()['sender'];

                    final loggedInUser = _auth.currentUser?.email;

                    if( messageSender == loggedInUser ){
                      isMe= true;
                    }else {
                      isMe = false;
                    }

                    final messageWidget = MessageBubble(text: messageText, sender: messageSender , isMe: isMe,);
                    messagesWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      children: messagesWidgets,


                    ),
                  );
                }
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textMessageController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                         textMessageController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': _auth.currentUser?.email,


                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  MessageBubble({required this.text, required this.sender , required this.isMe});

  @override
  Widget build(BuildContext context) {
    return isMe==true? Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(sender,style: TextStyle(fontSize: 12,color: Colors.black45),),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)),
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(text,
                style: TextStyle(fontSize: 15, color: Colors.white),),
            ),
          ),
        ],
      ),
    ):Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(fontSize: 12,color: Colors.black38),),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(text,
                style: TextStyle(fontSize: 15, color: Colors.black54),),
            ),
          ),
        ],
      ),
    );
  }
}
