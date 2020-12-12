import 'package:appsynergy_ganesh_assignment/auth/auth_implementation.dart';
import 'package:appsynergy_ganesh_assignment/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class ChatScreen extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback signedOut;
  ChatScreen({
    this.auth,
    this.signedOut,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String userName;
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUserEmail().then((email) {
      setState(() {
        final String userEmail = email;
        final endIndex = userEmail.indexOf("@");
        userName = userEmail.substring(0, endIndex);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "App Synergies",
          style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold
             ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton(
              child: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold),),
              onPressed: logOut),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              //margin: EdgeInsets.symmetric(horizontal: 5),
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("messages")
                      .orderBy(
                        "timestamp",
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ),
                      );
                    List<DocumentSnapshot> docs = snapshot.data.documents;

                    List<Widget> messages = docs
                        .map((doc) => Message(
                              user: doc.data['user'],
                              text: doc.data['text'],
                              timestamp: doc.data['timestamp'],
                              mine: userName == doc.data['user'],
                            ))
                        .toList();
                    return ListView(
                      controller: scrollController,
                      children: messages,
                    );
                  }),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      onSubmitted: (value) => sendChat(),
                      controller: messageController,
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Type a message",
                        hintStyle:
                            TextStyle( fontSize: 12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send
                    ,color: Colors.black,
                  ),
                  onPressed: sendChat,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void logOut() async {
    try {
      await widget.auth.signOut();
      widget.signedOut();
    } catch (e) {
      print("error :" + e.toString());
    }
  }

  Future<void> sendChat() async {
    if (messageController.text.length > 0) {
      await _firestore.collection("messages").add({
        'user': userName,
        'text': messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
