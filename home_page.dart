import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_attendiie/View/Students/markAttendi.dart';
import 'package:my_attendiie/View/Students/leaverequest.dart';


import 'Admin/editOrDelete.dart';
import 'Students/viewMyAttendence.dart';
import 'login_screen.dart';

class GridItem {
  final String title;
  final String imagePath;
  final Widget destinationScreen; // New property for destination screen

  GridItem({required this.title, required this.imagePath, required this.destinationScreen});
}

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<GridItem> gridItems = [

    GridItem(title: 'Mark Attendance', imagePath: 'assets/add.png', destinationScreen: AddScreen()),
    GridItem(title: 'View Attendance', imagePath: 'assets/approve.png', destinationScreen: ViewAttendanceScreen()),
    GridItem(title: 'Leave Request', imagePath: 'assets/request.png', destinationScreen: LeaveRequestDetailsScreen()),
    // Add more items as needed
  ];
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,


          backgroundColor: Colors.cyanAccent,

          title: Text("My Attendii",style: GoogleFonts.aladin(color: Colors.purpleAccent),),
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
            child: Text('Hey,Well Come!',
            style: GoogleFonts.abyssinicaSil(color: Colors.amberAccent,fontSize:20,fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Eassy to use Attendance Management. Mark your attendence ',
              style: GoogleFonts.abyssinicaSil(color: Colors.amberAccent,fontSize:13,fontWeight: FontWeight.bold),),
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
    );
  }
}