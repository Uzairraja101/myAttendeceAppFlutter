import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login_screen.dart';

class AddScreen extends StatefulWidget {
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController name = TextEditingController();
  TextEditingController rolln = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _initializeNameField();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      // Check if attendance already marked for this date
      bool attendanceExists = await checkAttendanceExists(pickedDate);

      if (attendanceExists) {
        // Show error or take appropriate action
        Fluttertoast.showToast(
          msg: "Attendance already marked for this date",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        setState(() {
          selectedDate = pickedDate;
          dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        String formattedTime = "${selectedTime.hour}:${selectedTime.minute}";
        timeController.text = formattedTime;
        // Format the time using the current context
      });
    }
  }


  void _clearFields() {
    rolln.clear();
    dateController.clear();
    timeController.clear();
  }

  Future<void> _initializeNameField() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        name.text = user.email ?? '';
      });
    }
  }

  Future<bool> checkAttendanceExists(DateTime date) async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await ref
          .where('userId', isEqualTo: user.uid)
          .where('date', isEqualTo: date.toLocal().toString().split(' ')[0])
          .get();

      return querySnapshot.docs.isNotEmpty;
    }
    return false;
  }

  Future<bool> isUserAuthenticated() async {
    User? user = _auth.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isUserAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError || snapshot.data == false) {
          return LoginScreen();
        }
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.purpleAccent),
            centerTitle: true,
            backgroundColor: Colors.cyanAccent,
            title: Text('Mark Attendance',style: GoogleFonts.aladin(color: Colors.purpleAccent),),

          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 12),
                    keyboardType: TextInputType.emailAddress,
                    controller: name,
                    decoration: InputDecoration(
                      fillColor: Colors.amberAccent,
                      filled: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                    controller: rolln,
                    decoration: InputDecoration(
                      fillColor: Colors.amberAccent,
                      filled: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      hintText: "Enter your Roll Number",
                      hintStyle: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Roll Number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month),
                                SizedBox(width: 10),
                                Text(
                                  dateController.text.isEmpty
                                      ? 'Select Date'
                                      : dateController.text,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () => _selectTime(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 10),
                                Text(
                                  timeController.text.isEmpty
                                      ? 'Select Time'
                                      : timeController.text,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: Colors.cyanAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () async {
                      // Check if attendance already marked for this date
                      bool attendanceExists = await checkAttendanceExists(selectedDate);

                      if (attendanceExists) {
                        // Show error or take appropriate action
                        Fluttertoast.showToast(
                          msg: "Attendance already marked for this date",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        // Proceed to add the attendance record to Firestore
                        String formattedDate = "${selectedDate.toLocal()}".split(' ')[0];
                        String formattedTime = "${selectedTime.hour}:${selectedTime.minute}";

                        ref.add({
                          'userId': _auth.currentUser?.uid,
                          'name': name.text,
                          'roll': rolln.text,
                          'date': formattedDate,
                          'time': formattedTime,
                        }).whenComplete(() {
                          Fluttertoast.showToast(
                            msg: "Attendance added successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          _clearFields();
                        });
                      }
                    },
                    child: Text(
                      'ADD',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
