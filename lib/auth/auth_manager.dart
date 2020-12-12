import 'package:appsynergy_ganesh_assignment/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'auth_implementation.dart';

import '../screens/login_screen.dart';

enum authStatus { signedout, signedIn }

class FirebaseAuthManager extends StatefulWidget {
  final AuthImplementation auth;

  FirebaseAuthManager({
    this.auth,
  });

  @override
  _FirebaseAuthManagerState createState() => _FirebaseAuthManagerState();
}

class _FirebaseAuthManagerState extends State<FirebaseAuthManager> {
  authStatus _authStatus = authStatus.signedout;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUserId().then((firebaseUserId) {
      setState(() {
        _authStatus = firebaseUserId == null ? authStatus.signedout : authStatus.signedIn;
      });
    }).catchError((onError){
      _authStatus = authStatus.signedout;
    });

  }

  void _signedIn() {
    setState(() {
      _authStatus = authStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = authStatus.signedout;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case authStatus.signedout:
        return LoginScreen(
          auth: widget.auth,
          signedIn: _signedIn,
        );
      case authStatus.signedIn:
        return ChatScreen(
          auth: widget.auth,
          signedOut: _signedOut,
        );
    }

    return null;
  }
}
