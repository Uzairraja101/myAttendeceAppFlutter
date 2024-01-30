import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAttendanceScreen extends StatefulWidget {
  final String initialDate;
  final String initialTime;
  final String documentId;

  EditAttendanceScreen({
    required this.initialDate,
    required this.initialTime,
    required this.documentId,
  });

  @override
  _EditAttendanceScreenState createState() => _EditAttendanceScreenState();
}

class _EditAttendanceScreenState extends State<EditAttendanceScreen> {
  late TextEditingController dateController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: widget.initialDate);
    timeController = TextEditingController(text: widget.initialTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purpleAccent),
        backgroundColor: Colors.cyanAccent,
        title: Text('Edit Attendance', style: GoogleFonts.aladin(color: Colors.purpleAccent),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Date:',
            style: GoogleFonts.aclonica(color: Colors.cyan),),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              controller: dateController,
              decoration: InputDecoration(
                fillColor: Colors.amberAccent,
                filled: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                hintText: "Enter New Date",
                hintStyle: GoogleFonts.aBeeZee(color: Colors.cyanAccent, fontSize: 12),
              ),
            ),
            SizedBox(height: 16),
            Text('Edit Time:',
              style: GoogleFonts.aclonica(color: Colors.cyan),),
            TextField(

              controller: timeController,
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,

              decoration: InputDecoration(
                fillColor: Colors.amberAccent,
                filled: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                hintText: "Enter New Date",
                hintStyle: GoogleFonts.aBeeZee(color: Colors.cyanAccent, fontSize: 12),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyanAccent, // Set your desired background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Set your desired border radius
                  ),),
                onPressed: () {
                  // Update the Firestore document with new data
                  FirebaseFirestore.instance.collection('users').doc(widget.documentId).update({
                    'date': dateController.text,
                    'time': timeController.text,
                  });

                  Navigator.pop(context); // Close the edit screen
                },
                child: Text('Save Changes',
                style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
