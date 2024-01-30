import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Utils/utils.dart';
import '../weiget/button.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  String registrationMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        centerTitle: true,
        backgroundColor: Colors.cyanAccent,
        leading: BackButton(
          color: Colors.purpleAccent,
        ),
        title: Text(
          "Create Account",
          style: GoogleFonts.aladin(color: Colors.purpleAccent),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 55,),
                Container(
                  height: 120,
                  width: 120,
                  child: Image(image: AssetImage('assets/signup.png')),
                ),
                SizedBox(height: 10,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        'Please Enter Your Email And Password',
                        style: TextStyle(color: Colors.amberAccent),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.amberAccent,
                          filled: true,
                          border: OutlineInputBorder(),
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email_outlined,color: Colors.purpleAccent,),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Your Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                          fillColor: Colors.amberAccent,
                          filled: true,
                          border: OutlineInputBorder(),
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock,color: Colors.purpleAccent,),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                                color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Your Password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),

                RoundButton(
                  title: 'Register',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _auth
                          .createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString())
                          .then((value) {
                        setState(() {
                          registrationMessage =
                          "User registered successfully!";
                          // Clear text fields
                          emailController.clear();
                          passwordController.clear();
                        });
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                      });
                    }
                  },
                ),

                // Display registration message
                Text(
                  registrationMessage,
                  style: TextStyle(color: Colors.green),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'or',
                       style: GoogleFonts.aclonica(fontSize:9,color: Colors.amberAccent),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        'Log-In',
                        style: GoogleFonts.aclonica(fontSize:11,color: Colors.cyanAccent),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
