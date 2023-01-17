import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'authForm.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: GoogleFonts.poppins()),

        backgroundColor: Colors.purple,
      ),
      body: Center(child: authForm()),
    );
  }
}
