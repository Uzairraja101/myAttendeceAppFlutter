import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class IndividualAttendanceScreen extends StatefulWidget {
  final String name;

  IndividualAttendanceScreen({
    required this.name,
    required DateTime startDate,
    required DateTime endDate,
  });

  @override
  _IndividualAttendanceScreenState createState() =>
      _IndividualAttendanceScreenState();
}

class _IndividualAttendanceScreenState
    extends State<IndividualAttendanceScreen> {
  late DateTime startDate;
  late DateTime endDate;
  int presentCount = 0;
  int absentCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize start and end dates with the current date
    startDate = DateTime.now();
    endDate = DateTime.now();
    updateAttendanceCounts();
  }

  void updateAttendanceCounts() {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: widget.name)
        .where('date',
        isGreaterThanOrEqualTo: startDate.toLocal().toString().split(' ')[0])
        .where('date',
        isLessThanOrEqualTo: endDate.toLocal().toString().split(' ')[0])
        .get()
        .then((QuerySnapshot querySnapshot) {
      int present = 0;
      int absent = 0;
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        var documentData = document.data() as Map<String, dynamic>;
        String attendanceStatus = documentData['status'];
        if (attendanceStatus == 'Present') {
          present++;
        } else if (attendanceStatus == 'Absent') {
          absent++;
        }
      }
      setState(() {
        presentCount = present;
        absentCount = absent;
      });
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedStartDate != null && pickedStartDate != startDate) {
      setState(() {
        startDate = pickedStartDate;
        updateAttendanceCounts();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedEndDate != null && pickedEndDate != endDate) {
      setState(() {
        endDate = pickedEndDate;
        updateAttendanceCounts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purpleAccent),
        backgroundColor: Colors.cyanAccent,
        title: Text('Individual Attendance',
        style: GoogleFonts.aladin(color: Colors.purpleAccent),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyanAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(150, 40),
                  ),
                  onPressed: () => _selectStartDate(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 8),// Add your desired icon here
                       // Adjust the spacing between icon and text
                      Text('Start Date',),
                    ],
                  ),
                ),

                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyanAccent, // Set the background color
                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(10.0), // Set the border radius
                    ),
                    minimumSize: Size(150, 40),
                  ),
                  onPressed: () => _selectEndDate(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 5),// Add your desired icon here
                       // Adjust the spacing between icon and text
                      Text('Start Date'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('name', isEqualTo: widget.name)
                  .where('date',
                  isGreaterThanOrEqualTo:
                  startDate.toLocal().toString().split(' ')[0])
                  .where('date',
                  isLessThanOrEqualTo:
                  endDate.toLocal().toString().split(' ')[0])
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text(
                      'No attendance records found for ${widget.name} in the selected date range.\n Or\n Select a date'
                  ,style: GoogleFonts.agdasima(color: Colors.orange,),);
                }

                // Create a map to store attendance status for each date
                Map<String, String> attendanceStatusMap = {};

                for (var document in snapshot.data!.docs) {
                  var documentData = document.data() as Map<String, dynamic>;
                  String date = documentData['date'];
                  attendanceStatusMap[date] = 'Present';
                }

                // Iterate through the range of dates and mark 'Absent' for dates without data
                List<Widget> attendanceWidgets = [];
                for (DateTime date = startDate;
                date.isBefore(endDate.add(Duration(days: 1)));
                date = date.add(Duration(days: 1))) {
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(date);
                  String attendanceStatus =
                      attendanceStatusMap[formattedDate] ?? 'Absent';
                  Color statusColor = attendanceStatus == 'Present'
                      ? Colors.green
                      : Colors.red;

                  attendanceWidgets.add(
                    Card(
                      child: ListTile(
                        title: Text('Name: ${widget.name}'),
                        subtitle: Text(
                          'Date: $formattedDate, Status: $attendanceStatus',
                          style: TextStyle(
                            color: statusColor,
                          ),
                        ),
                        // Add other fields as needed
                      ),
                    ),
                  );
                }

                return ListView(
                  children: attendanceWidgets,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
