import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/utils.dart';
import '../weiget/button.dart';
import 'Admin/adminHome.dart';
import 'home_page.dart';
import 'login_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Fixed admin credentials
  static const String adminEmail = "admin@gmail.com";
  static const String adminPassword = "admin123";

  bool _obscureText = true;

  void login() {
    // Check if entered credentials match the fixed admin credentials
    if (emailController.text == adminEmail && passwordController.text == adminPassword) {
      Utils().toastMessage("Admin logged in: $adminEmail");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminHomeScreen()),
      );
    } else {
      Utils().toastMessage("Invalid credentials");
    }
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
            "Admin LogIn",
            style: GoogleFonts.aladin(color: Colors.purpleAccent),
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
                      SizedBox(height: 100,),
                      Container(
                        height: 70,
                        width: 70,
                        child: Image(image: AssetImage('assets/admin.png')),
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
                  title: 'LogIn as Admin'
                      '',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "If Want To Log in as Student",
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
