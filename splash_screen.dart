import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../services/splash_services.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin(context);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/splash.png')),
            SizedBox(height: 10,),
            Text('MARK YOUR ATTENDANCE',
            style: GoogleFonts.aboreto(color: Colors.amberAccent,fontSize: 17,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text('Eassy to use Attendance Management ',
              style: GoogleFonts.aBeeZee(color: Colors.amberAccent,fontSize: 12),),
            Text(' solution for your school',
              style: GoogleFonts.aBeeZee(color: Colors.amberAccent,fontSize: 12),)

          ],
        ),
      ),
    );
  }
}
