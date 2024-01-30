import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAttendanceScreen extends StatefulWidget {
  @override
  _ViewAttendanceScreenState createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference attendanceRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purpleAccent),
        backgroundColor: Colors.cyanAccent,
        title: Text('View My Attendance',style: GoogleFonts.aladin(color: Colors.purpleAccent),),
        centerTitle: true,
      ),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Text('Error fetching user');
          }

          User? user = snapshot.data;
          return StreamBuilder<QuerySnapshot>(
            stream: attendanceRef.where('userId', isEqualTo: user?.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              QuerySnapshot querySnapshot = snapshot.data!;

              if (querySnapshot.size == 0) {
                return Center(
                  child: Text('No attendance records found.'),
                );
              }

              return ListView.builder(
                itemCount: querySnapshot.size,
                itemBuilder: (context, index) {
                  var attendanceData = querySnapshot.docs[index].data() as Map<String, dynamic>;
                  return Card(
                    color: Colors.amberAccent,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        attendanceData['name'],
                        style: GoogleFonts.habibi(color: Colors.black, fontSize: 14),
                      ),
                      subtitle: Text(
                        'Date: ${attendanceData['date']}            Time in: ${attendanceData['time']}',
                        style: GoogleFonts.abhayaLibre(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
