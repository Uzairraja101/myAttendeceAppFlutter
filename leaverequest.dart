import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveRequestDetailsScreen extends StatefulWidget {
  @override
  _LeaveRequestDetailsScreenState createState() => _LeaveRequestDetailsScreenState();
}

class _LeaveRequestDetailsScreenState extends State<LeaveRequestDetailsScreen> {
  final TextEditingController dateController = TextEditingController();

  final auth = FirebaseAuth.instance;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = auth.currentUser;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  void submitLeaveRequest() {
    // Ensure there is a user before trying to access their email
    if (currentUser != null) {
      // Store leave request in Firebase
      FirebaseFirestore.instance.collection('leaveRequests').add({
        'email': currentUser!.email,
        'date': dateController.text,
        'status': 'pending', // You can add more fields as needed
      });

      // Navigate to a confirmation screen or any other screen
      // You can modify this according to your application flow
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purpleAccent),
        backgroundColor: Colors.cyanAccent,
        title: Text('Leave Request',style: GoogleFonts.aladin(color: Colors.purpleAccent),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.amberAccent,
              borderRadius: BorderRadius.only(topRight:Radius.circular(4),topLeft:Radius.circular(4))),
              child:Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Email: ${currentUser?.email ?? 'Unknown'}',
                  style: GoogleFonts.actor(fontSize: 16,),

                ),
              ), 
            ),

            SizedBox(height: 20),
            InkWell(
              onTap: () => _selectDate(context),
              child: IgnorePointer(
                child: TextField(

                  controller: dateController,
                  decoration: InputDecoration(
                    fillColor: Colors.amberAccent,
                    filled: true,
                    labelText: 'Date',
                    labelStyle: GoogleFonts.actor(fontSize: 16,) ,
                    suffixIcon: Icon(Icons.calendar_today,color: Colors.black,),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.cyanAccent, // Set the button color here
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                ),),
              onPressed: submitLeaveRequest,
              child: Text('Submit Leave Request',
              style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
