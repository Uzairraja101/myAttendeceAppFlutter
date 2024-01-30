import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'editScreen.dart';


class AttendanceCard extends StatelessWidget {
  final String studentName;
  final String attendanceDate;
  final String attendanceTime;
  final String documentId;

  AttendanceCard({
    required this.studentName,
    required this.attendanceDate,
    required this.attendanceTime,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.cyan,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              studentName,
              style: GoogleFonts.alata(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  "Date: $attendanceDate",
                  style: GoogleFonts.alata(fontSize: 9),
                ),
                Spacer(),
                Text(
                  "Time in: $attendanceTime",
                  style: GoogleFonts.alata(fontSize: 9),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Navigate to the edit screen with necessary data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAttendanceScreen(
                      initialDate: attendanceDate,
                      initialTime: attendanceTime,
                      documentId: documentId,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Remove the item from the data source
                FirebaseFirestore.instance.collection('users').doc(documentId).delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}

