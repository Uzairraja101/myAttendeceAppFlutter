import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceDetailsScreen extends StatelessWidget {
  final String studentEmail;

  AttendanceDetailsScreen({required this.studentEmail});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _attendanceStream = FirebaseFirestore.instance
        .collection('attendance')
        .where('email', isEqualTo: studentEmail)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details'),
      ),
      body: StreamBuilder(
        stream: _attendanceStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No attendance details available for $studentEmail"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var documentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              var attendanceDate = documentData.containsKey('date')
                  ? documentData['date']
                  : 'Date not available';

              var attendanceTime = documentData.containsKey('time')
                  ? documentData['time']
                  : 'Time not available';

              return ListTile(
                title: Text('Date: $attendanceDate'),
                subtitle: Text('Time: $attendanceTime'),
              );
            },
          );
        },
      ),
    );
  }
}
