import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveApprovalScreen extends StatefulWidget {
  @override
  _LeaveApprovalScreenState createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  String _feedbackMessage = ''; // New variable for feedback message
  int respondedCount = 0;
  int pendingCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purpleAccent),
        backgroundColor: Colors.cyanAccent,
        title: Text('Leave Response',
        style: GoogleFonts.aladin(color: Colors.purpleAccent),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('leaveRequests').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var leaveRequests = snapshot.data!.docs;
          respondedCount = 0;
          pendingCount = 0;

          for (var request in leaveRequests) {
            var data = request.data() as Map<String, dynamic>;
            var isAlreadyProcessed = data['status'] == 'approved' || data['status'] == 'rejected';

            if (isAlreadyProcessed) {
              respondedCount++;
            } else {
              pendingCount++;
            }
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Responded: $respondedCount', style: TextStyle(color: Colors.amberAccent)),
                    Text('Pending: $pendingCount', style: TextStyle(color: Colors.amberAccent)),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: leaveRequests.length,
                  itemBuilder: (context, index) {
                    var request = leaveRequests[index].data() as Map<String, dynamic>;
                    var requestId = leaveRequests[index].id;
                    var isAlreadyProcessed = request['status'] == 'approved' || request['status'] == 'rejected';
                    var backgroundColor = isAlreadyProcessed ? Colors.white : Colors.green; // Change background color

                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        // Handle the delete logic here
                        deleteLeaveRequest(requestId);
                        showFeedbackMessage('Request deleted');
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        color: backgroundColor, // Set background color
                        child: ListTile(
                          title: Text('Email: ${request['email']}'),
                          subtitle: Text('Date: ${request['date']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: isAlreadyProcessed
                                    ? () => showFeedbackMessage('Already responded')
                                    : () {
                                  // Handle the approval logic here
                                  approveLeaveRequest(requestId);
                                  showFeedbackMessage('Request approved');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: isAlreadyProcessed
                                    ? () => showFeedbackMessage('Already responded')
                                    : () {
                                  // Handle the rejection logic here
                                  rejectLeaveRequest(requestId);
                                  showFeedbackMessage('Request rejected');
                                },
                              ),

                            ],
                          ),

                        ),
                      ),
                    );
                  },
                ),
              ),Text('Slide left to delete!',
                style: TextStyle(color: Colors.amberAccent),),
            ],
          );
        },
      ),
    );
  }

  void approveLeaveRequest(String requestId) {
    // Update the leave request status to 'approved' in Firestore
    FirebaseFirestore.instance.collection('leaveRequests').doc(requestId).update({
      'status': 'approved',
    });
  }

  void rejectLeaveRequest(String requestId) {
    // Update the leave request status to 'rejected' in Firestore
    FirebaseFirestore.instance.collection('leaveRequests').doc(requestId).update({
      'status': 'rejected',
    });
  }

  void deleteLeaveRequest(String requestId) {
    // Delete the leave request from Firestore
    FirebaseFirestore.instance.collection('leaveRequests').doc(requestId).delete();
  }

  void showFeedbackMessage(String message) {
    // Set the feedback message and rebuild the widget to show the SnackBar
    setState(() {
      _feedbackMessage = message;
    });

    // Show a SnackBar to provide feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyanAccent,
        content: Text(message, style: TextStyle(color: Colors.black)),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
