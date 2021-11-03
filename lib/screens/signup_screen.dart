import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:friendster/screens/login_screen.dart';
import 'navigation_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      _signup(_userEmail.trim(), _userName.trim(), _userPassword.trim());
    }
  }

  void _signup(String email, String username, String password) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .set({'username': username, 'email': email});
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => NavigationScreen()), (Route<dynamic> route) => false);
    } on PlatformException catch (e) {
      var message = 'An error occurred, please check your credentials';
      if (e.message != null) {
        message = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (_isLoading) CircularProgressIndicator(),
                  if (!_isLoading)
                    SizedBox(
                      width: 500,
                      child: ElevatedButton(
                        child: Text('Signup'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellowAccent),
                        ),
                        onPressed: _submit,
                      ),
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  if (!_isLoading)
                    TextButton(
                      child: Text(
                        'I already have an account',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.yellowAccent),
                      ),
                      onPressed: () {
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
