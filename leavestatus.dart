import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveStatusScreen extends StatefulWidget {
  @override
  _LeaveStatusScreenState createState() => _LeaveStatusScreenState();
}

class _LeaveStatusScreenState extends State<LeaveStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purpleAccent),

        backgroundColor: Colors.cyanAccent,
        title: Text('Leave Status',
          style: GoogleFonts.aladin(color: Colors.purpleAccent),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('leaveRequests').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var leaveRequests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leaveRequests.length,
            itemBuilder: (context, index) {
              var request = leaveRequests[index].data() as Map<String, dynamic>;
              var leaveStatus = request['status'];

              Color containerColor = leaveStatus == 'rejected' ? Colors.red : Colors.green;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Email: ${request['email']}'),
                  subtitle: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          leaveStatus,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
