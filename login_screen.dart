import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_attendiie/View/signup_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_fonts/google_fonts.dart';

import '../Utils/utils.dart';
import '../weiget/button.dart';
import 'adminLogIn.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _obscureText = true;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text.toString(),
    ).then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostScreen()),
      );
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.cyanAccent,
          automaticallyImplyLeading: false,
          title: Text(
            "Log In",style: GoogleFonts.aladin(color: Colors.purpleAccent),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 80,),
                      Container(
                        height: 100,
                        width: 100,
                        child: Image(image: AssetImage('assets/login.png')),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Please Enter Valid Details',
                        style: TextStyle(color: Colors.amberAccent),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.amberAccent,
                          filled: true,
                          border: OutlineInputBorder(

                          ),
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
                      SizedBox(height: 8),
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
                          hintStyle: TextStyle(color: Colors.black),
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
                  title: 'Log In',

                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },

                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'or',style:
                        GoogleFonts.aclonica(fontSize:9,color: Colors.amberAccent),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign-Up',
                        style: GoogleFonts.aclonica(fontSize:11,color: Colors.cyanAccent),
                      ),
                    )
                  ],

                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>AdminLoginScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,bottom: 0),
                    child: Text('Admin',
                    style: GoogleFonts.alice(color: Colors.purpleAccent),),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
