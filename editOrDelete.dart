import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'deleteAttendii.dart';
import 'editScreen.dart';
import 'getLeaveReq.dart';


class EditOrDelete extends StatefulWidget {
  @override
  State<EditOrDelete> createState() => _EditOrDeleteState();
}

class _EditOrDeleteState extends State<EditOrDelete> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
    FirebaseFirestore.instance.collection('users').snapshots();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purpleAccent),
        backgroundColor: Colors.cyanAccent,
        title: Text(
          'Edit or Delete ',
          style: GoogleFonts.aladin(color: Colors.purpleAccent)

        ),

      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
              stream: _usersStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Text("No data available");
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    var studentName = snapshot.data!.docs[index]['name'];
                    var documentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                    // Check if the 'date' field exists in the document data
                    var attendanceDate = documentData.containsKey('date')
                        ? documentData['date']
                        : 'Date not available';

                    // Check if the 'time' field exists in the document data
                    var attendanceTime = documentData.containsKey('time')
                        ? documentData['time']
                        : 'Time not available';

                    return AttendanceCard(
                      studentName: studentName,
                      attendanceDate: attendanceDate,
                      attendanceTime: attendanceTime,
                      documentId: snapshot.data!.docs[index].id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
