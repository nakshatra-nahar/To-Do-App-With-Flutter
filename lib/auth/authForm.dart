// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class authForm extends StatefulWidget {
  const authForm({super.key});

  @override
  State<authForm> createState() => _authFormState();
}

class _authFormState extends State<authForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false;
  var email = "";
  var password = "";
  var username = "";

  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  startAuthentication() {
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formKey.currentState!.save();
      submitForm(username, email, password);
    }
  }

  submitForm(String username, String email, String password) async {
    try {
      if (isLogin) {
        print('rcoket1');
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        print('////////-------- SUCCESS Login ---------///////////////');
      } else {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        var uid = FirebaseAuth.instance.currentUser?.uid;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .set({'email': email, 'username': username, 'password': password});

        print('////////-------- SUCCESS User Created ---------///////////////');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        print('////////-------- Error ---------///////////////');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        print('////////-------- Error ---------///////////////');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !isLogin
                          ? TextFormField(
                              controller: _userNameController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.white),
                                  ),
                                  hintText: 'Enter Your Username',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter Username";
                                } else {
                                  return null;
                                }
                              },
                              key: ValueKey('Username'),
                              onSaved: (value) {
                                username = value!;
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                            ),
                            hintText: 'Enter Your Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (!(value!.contains('@'))) {
                            return "Enter Correct Email";
                          } else {
                            return null;
                          }
                        },
                        key: ValueKey('emailKey'),
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                            ),
                            hintText: 'Enter Your Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        onSaved: (value) {
                          password = value!;
                        },
                        validator: (value) {
                          if (value!.length<=6) {
                            return "Enter Password Of Length More Than 6";
                          } else {
                            return null;
                          }
                        },
                        key: ValueKey('passwordKey'),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 8, // thickness
                                      color: Colors.purple // color
                                      ),
                                  // border radius
                                  borderRadius: BorderRadius.circular(16))),
                          onPressed: () {
                            startAuthentication();
                          },
                          child: isLogin
                              ? Text('Sign In',
                                  style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold))
                              : Text('Sign Up',
                                  style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (isLogin == true) {
                                isLogin = false;
                              } else {
                                isLogin = true;
                              }
                            });
                          },
                          child: Text(
                            !isLogin ? 'Already A Member?' : 'Sign-Up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveOnPress() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }
}
