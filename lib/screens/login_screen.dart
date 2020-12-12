import 'package:appsynergy_ganesh_assignment/auth/auth_implementation.dart';
import 'package:appsynergy_ganesh_assignment/models/dialogbox.dart';
import 'package:flutter/material.dart';


enum FormType { login, register }

class LoginScreen extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback signedIn;
  LoginScreen({
    this.auth,
    this.signedIn,
  });
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DialogBox dialogBox = DialogBox();

  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  bool showDialog = false;
  String _email = "";
  String _password = "";

  void submitForm() async {

    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

       if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
         dialogBox.information(context, "Error", "Please Enter a valid Email Address");
         return;
       }

       if(_password.length<6){
         dialogBox.information(context, "Error", "Please Enter minimum 6 digits password");
         return;
       }


      setState(() {
        showDialog = true;
      });
      try {
        if (_formType == FormType.login) {
          String authResult = await widget.auth.signIn(_email, _password);
          setState(() {
            showDialog = false;
          });
          print(authResult);
        } else {
          String authResult = await widget.auth.signUp(_email, _password);
          setState(() {
            showDialog = false;
          });
          dialogBox.information(context, "Congratulations",
              "Your account has been created successfully");
          print(authResult);
        }
        widget.signedIn();
      }
      catch (e) {

        print ("Msg"+e.toString());
        setState(() {
          showDialog = false;
        });
        dialogBox.information(context, "Error", e.toString());
      }

    }
  }

  void switchForm() {
    formKey.currentState.reset();
    setState(() {
      _formType =  _formType==FormType.login? FormType.register: FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: Container(
        margin: EdgeInsets.all(25),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Text(
                "App Synergies",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 15.0),
                          blurRadius: 15.0),
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, -10.0),
                          blurRadius: 10.0),
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
                  child: Column(
                    children: formInputFields(),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: submitForm,
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child:
                            showDialog?  CircularProgressIndicator():
                            Text(
                              _formType==FormType.login ?  "LOGIN" :"Register" ,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !showDialog,
                      child: FlatButton(
                        child: Text(
                          _formType==FormType.login ? "Don't have an account? Register": "Have an Account ? Login",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        onPressed: () {
                          switchForm();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> formInputFields() {
    return [
      TextFormField(
        style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        validator: (value) {
          return value.isEmpty ? 'Please Enter Email' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10,
      ),
      TextFormField(
        style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? 'Please Enter Password' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
      ),
    ];
  }


}
