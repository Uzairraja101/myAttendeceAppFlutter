import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_attendiie/View/Admin/editOrDelete.dart';

import 'viewAll.dart';
import '../login_screen.dart';
import 'getLeaveReq.dart';
import 'leavestatus.dart';
class GridItem {
  final String title;
  final String imagePath;
  final Widget destinationScreen; // New property for destination screen

  GridItem({required this.title, required this.imagePath, required this.destinationScreen});
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<GridItem> gridItems = [
    GridItem(title: 'Edit Attendence', imagePath: 'assets/edit.png', destinationScreen:EditOrDelete()),
    GridItem(title: 'Record', imagePath: 'assets/result.png', destinationScreen: DisplayAttendanceScreen()),
    GridItem(title: 'Leave Response', imagePath: 'assets/response.png', destinationScreen: LeaveApprovalScreen()),
    GridItem(title: 'Leave Status', imagePath: 'assets/accept.png', destinationScreen: LeaveStatusScreen()),

  ];
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,


        backgroundColor: Colors.cyanAccent,

        title: Text("Admin",style: GoogleFonts.aladin(color: Colors.purpleAccent),),
        actions: [IconButton(
            color: Colors.black,
            onPressed: (){
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>LoginScreen()));
              });

            },
            icon: Icon(Icons.logout,color: Colors.purpleAccent,))],
      ),

      body: ListView(
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Well Come! Admin',
              style: GoogleFonts.abyssinicaSil(color: Colors.amberAccent,fontSize:20,fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('You can View Record,responde a request and see active status here ',
              style: GoogleFonts.abyssinicaSil(color: Colors.amber,fontSize:13,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(height: 6,
              width: 70,
              decoration: BoxDecoration(color: Colors.cyanAccent),),
          ),

          SizedBox(height: 17,),

          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: 220
            ),
            itemCount: gridItems.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the corresponding screen when grid item is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => gridItems[index].destinationScreen,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.cyan[100],
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          gridItems[index].imagePath,
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(height: 10),
                        Text(
                          gridItems[index].title,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );;
  }
}
